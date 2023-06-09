USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_0003_MakeProgramsToFillInPlanCodes]    Script Date: 5/16/2023 9:50:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[sp_0003_MakeProgramsToFillInPlanCodes] AS

IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'ProgramsToFillInPlanCodes')
	DROP TABLE ProgramsToFillInPlanCodes

SELECT 
Plan_Code, 
New_Used, 
Rate_Book, 
Plan_Description, 
Program, 
SUM([Count]) AS Count
INTO ProgramsToFillInPlanCodes
FROM  Programs
GROUP BY 
Plan_Code, 
New_Used, 
Rate_Book, 
Plan_Description, 
Program
ORDER BY 
Plan_Code, 
New_Used, 
Rate_Book, 
Plan_Description, 
Program








GO
