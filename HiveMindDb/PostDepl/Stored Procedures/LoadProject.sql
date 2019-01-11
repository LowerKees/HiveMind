CREATE PROCEDURE [PostDepl].[LoadProject]
AS
	BEGIN
		WITH CTE AS (
			SELECT ProjectName         = N'StackIntegrator'
				   , ProjectSummary    = CONCAT(N'Our solution to checking if your Analysis Services ',
						N'project still connects to your database project. All without having to deploy ',
						N'to an instance on prem, or service in the Azure Cloud.')
				   , LanguagePrimary   = N'C#'
				   , LanguageSecondary = N'XML'
				   , LanguageTertiary  = NULL
				   , Remarks		   = NULL
				   , GitHubUrl         = N'https://github.com/LowerKees/StackIntegrator'
			UNION ALL
			SELECT ProjectName         = N'BattleShip'
				   , ProjectSummary    = CONCAT(N'Pet project. A single player guessing game. The goal is ',
						N'to sink all opponent''s ships. Feel free to participate to make Sql Server a ',
						N'Battle Ship opponent to recon with.')
				   , LanguagePrimary   = N'T-SQL'
				   , LanguageSecondary = NULL
				   , LanguageTertiary  = NULL
				   , Remarks           = N'(game language is Dutch)'
				   , GitHubUrl         = N'https://github.com/LowerKees/StackIntegrator'
		)
		MERGE INTO Proj.Project AS tgt
		USING (
			SELECT * 
				, AttributeHash = HASHBYTES('SHA2_512', CONCAT(ProjectName, '|',
					ProjectSummary, '|',
					LanguagePrimary, '|', 
					LanguageSecondary, '|', 
					LanguageTertiary, '|',
					Remarks, '|',
					GitHubUrl, '|')
					)
			FROM CTE) AS src
			ON tgt.ProjectName = src.ProjectName
			WHEN MATCHED AND (tgt.AttributeHash <> src.AttributeHash)
			THEN UPDATE 
			SET tgt.ProjectSummary = src.ProjectSummary
				, tgt.LanguagePrimary   = src.LanguagePrimary  
				, tgt.LanguageSecondary = src.LanguageSecondary
				, tgt.LanguageTertiary  = src.LanguageTertiary 
				, tgt.Remarks           = src.Remarks          
				, tgt.GitHubUrl         = src.GitHubUrl         
			WHEN NOT MATCHED BY TARGET
			THEN INSERT (
				ProjectSummary
				, LanguagePrimary  
				, LanguageSecondary
				, LanguageTertiary 
				, Remarks          
				, GitHubUrl
				, AttributeHash
			)
			VALUES (
				ProjectSummary
				, LanguagePrimary  
				, LanguageSecondary
				, LanguageTertiary 
				, Remarks          
				, GitHubUrl
				, AttributeHash
			);
			
	END
