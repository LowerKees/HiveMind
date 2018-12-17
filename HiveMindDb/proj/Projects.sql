CREATE TABLE [dbo].[Projects]
(
	[ProjectId] INT NOT NULL PRIMARY KEY,
	[ProjectName] NVARCHAR(128) NOT NULL,
	[ProjectLanguagePrimary] NVARCHAR(128) NULL,
	[ProjectLanguageSecondary] NVARCHAR(128) NULL,
	[ProjectLanguageTertiary] NVARCHAR(128) NULL,
	[GitHubUrl] NVARCHAR(1000) NULL
);
