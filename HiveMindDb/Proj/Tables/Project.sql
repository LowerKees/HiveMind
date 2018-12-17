CREATE TABLE [Proj].[Project]
(
	[ProjectId]         INT NOT NULL PRIMARY KEY,
	[ProjectName]       NVARCHAR(128) NOT NULL,
	[ProjectSummary]    NVARCHAR(500) NOT NULL,
	[LanguagePrimary]   NVARCHAR(128) NULL,
	[LanguageSecondary] NVARCHAR(128) NULL,
	[LanguageTertiary]  NVARCHAR(128) NULL,
	[Remarks]			NVARCHAR(256) NULL,
	[GitHubUrl]         NVARCHAR(128) NULL,
	[AttributeHash]     BINARY(64) NULL
)
