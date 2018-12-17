CREATE TABLE [proj].[Project]
(
	[ProjectId] INT NOT NULL PRIMARY KEY,
	[ProjectName] NVARCHAR(128) NOT NULL,
	[ProjectSummary] NVARCHAR(500) NOT NULL,
	[LanguagePrimary] NVARCHAR(128) NULL,
	[LanguageSecondary] NVARCHAR(128) NULL,
	[LanguageTertiary] NVARCHAR(128) NULL,
	[GitHubUrl] NVARCHAR(128) NULL
)
