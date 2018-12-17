CREATE PROCEDURE [Utils].[HashAttributes]
	@table_schema SYSNAME,
	@table_name SYSNAME,
	@ignore_columns NVARCHAR(1000)
AS
	BEGIN
		-- Determine column list
		SELECT cols.column_name
		FROM INFORMATION_SCHEMA.COLUMNS AS cols
		WHERE cols.TABLE_NAME = @table_name
		  AND cols.TABLE_SCHEMA = @table_schema
		ORDER BY cols.ORDINAL_POSITION ASC;
	END