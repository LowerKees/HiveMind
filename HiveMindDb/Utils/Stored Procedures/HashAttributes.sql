CREATE PROCEDURE [Utils].[HashAttributes]
	@table_schema SYSNAME,
	@table_name SYSNAME,
	@ignore_columns NVARCHAR(1000)
AS
	BEGIN
		-- Determine column list
		SELECT ColumName = cols.name 
			, ColumnDataType = typ.name
			, ColumnPrecision = cols.precision
			, ColumnScale = cols.scale
			, ColumnLength = cols.max_length
			, IsPrimaryKey = CASE idxcols.is_included_column WHEN 0 THEN 1 ELSE 0 END
			, IsIncludedColumn = ISNULL(idxcols.is_included_column, 0)
			, OrdinalPosition = cols.column_id
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

	END