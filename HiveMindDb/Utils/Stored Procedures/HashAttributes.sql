CREATE PROCEDURE [Utils].[HashAttributes]
	@table_schema SYSNAME,
	@table_name SYSNAME,
	@ignore_columns NVARCHAR(1000) = NULL
AS
	BEGIN
		DECLARE
			@msg NVARCHAR(128);			

		-- Isolate neccessary metadata
		DROP TABLE IF EXISTS #ColumnMetadata;
		SELECT ColumnName = cols.name 
			, ColumnDataType = typ.name
			, ColumnPrecision = cols.precision
			, ColumnScale = cols.scale
			, ColumnLength = cols.max_length
			, IsPrimaryKey = CASE idxcols.is_included_column WHEN 0 THEN 1 ELSE 0 END
			, IsIncludedColumn = ISNULL(idxcols.is_included_column, 0)
			, OrdinalPosition = cols.column_id
		INTO #ColumnMetadata
		FROM sys.columns AS cols
		JOIN sys.systypes AS typ 
			ON cols.system_type_id = typ.xusertype
		JOIN sys.tables AS tabs
			ON cols.object_id = tabs.object_id
		JOIN sys.schemas AS sch
			ON tabs.schema_id = sch.schema_id
		LEFT JOIN sys.indexes AS idx
			ON idx.object_id = tabs.object_id
		LEFT JOIN sys.index_columns AS idxcols
			ON idxcols.index_id = idx.index_id
			AND idxcols.column_id = cols.column_id
			AND idxcols.object_id = idx.object_id
		WHERE OBJECT_NAME(tabs.OBJECT_ID) = 'Project' -- TODO: replace with parameter value
		  AND sch.name = 'Proj' -- TODO: replace with parameter value
		  AND idx.is_primary_key = 1
		  AND cols.name != 'AttributeHash';

		-- Cast data types to string
		DROP TABLE IF EXISTS #CastedData;
		SELECT CastedColumns =  
			CASE 
				-- do not transfor string data types
				WHEN src.ColumnDataType IN ('NVARCHAR','VARCHAR','NCHAR','CHAR','NTEXT','TEXT') THEN src.ColumnName
				-- cast integers to nvarchar(20)
				WHEN src.ColumnDataType IN ('TINYINT','SMALLINT','INT','BIGINT') THEN CONCAT('CAST(', src.ColumnName, ' AS NVARCHAR(20))')
				-- cast date data type to yyyymmdd
				WHEN src.ColumnDataType = 'DATE' THEN CONCAT('CONVERT(NVARCHAR(8), ', src.ColumnName, ', 112)')
				-- cast datetime data types to yyyymmdd hh:mi:ss.mmmm
				WHEN src.ColumnDataType IN ('DATETIME','DATETIME2') THEN CONCAT('CONVERT(NVARCHAR(23), ', src.ColumnName, ', 112)')
				-- cast numerics and decimals to corresponding string
				WHEN src.ColumnDataType IN ('DECIMAL','NUMERIC') THEN CONCAT('CAST(', src.ColumnName, ' AS NVARCHAR(39))')
				-- cast floats and reals to corresponding string
				WHEN src.ColumnDataType IN ('float','real') THEN CONCAT('CAST(', src.ColumnName, ' AS NVARCHAR(54))')
				ELSE NULL
			END
		INTO #CastedData
		FROM #ColumnMetadata AS src;

		BEGIN TRY
			-- Perform checks on casted data
			IF EXISTS (
				SELECT *
				FROM #CastedData
				WHERE CastedColumns IS NULL
				)
				BEGIN
					SET @msg = N'Data type from table cannot be hashed.';
					THROW 50000, @msg, 1;
				END

			-- Build column list for hashing
			DECLARE @ColumnList NVARCHAR(4000);

			SELECT @ColumnList = CONCAT(@ColumnList + ',', CastedColumns, ', ''|''')
			FROM #CastedData;

			SET @ColumnList = CONCAT('CONVERT(BINARY(32), CONCAT(', @ColumnList, '))');

			-- Build update statement
			DECLARE @Update NVARCHAR(1000);

			SET @Update = CONCAT('
				UPDATE tgt
				SET tgt.AttributeHash = ', @ColumnList, '
				FROM ', @table_schema, '.', @table_name, ' AS tgt;');

			PRINT @Update;
				
		END TRY
		BEGIN CATCH
			DECLARE
				@ErrorNumber INT,
				@ErrorState INT,
				@ErrorMessage NVARCHAR(1000),
				@ErrorLine INT;
			SELECT
				@ErrorMessage = ERROR_MESSAGE()
				, @ErrorNumber = ERROR_NUMBER()
				, @ErrorState = ERROR_STATE()
				, @ErrorLine = ERROR_LINE();

			PRINT N'Hashing function did not complete properly. Please check previous error messages.';
			PRINT CONCAT(N'Error found at line ', CAST(@ErrorLine AS NVARCHAR(100)));
			THROW @ErrorNumber, @ErrorMessage, @ErrorState;
		END CATCH
	END