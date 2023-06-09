USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_0002_MakePrograms]    Script Date: 5/16/2023 9:50:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[sp_0002_MakePrograms] AS


IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'Programs')
	DROP TABLE Programs


SELECT 
GSFSContract_Detail.Insurance_Carrier, 
GSFSContract_Detail.Plan_Code, 
GSFSContract_Detail.New_Used, 
GSFSContract_Detail.Rate_Book, 
PlanCodes.Plan_Description, 
PlanCodes.Program, 
COUNT(GSFSContract_Detail.Contract_Id) AS [Count]
Into Programs
FROM GSFSContract_Detail LEFT OUTER JOIN PlanCodes ON 
GSFSContract_Detail.Rate_Book = PlanCodes.Rate_Book AND 
GSFSContract_Detail.New_Used = PlanCodes.New_Used AND 
GSFSContract_Detail.Plan_Code = PlanCodes.Plan_Code
GROUP BY 
GSFSContract_Detail.Insurance_Carrier, 
GSFSContract_Detail.Plan_Code, 
GSFSContract_Detail.New_Used, 
GSFSContract_Detail.Rate_Book, 
PlanCodes.Plan_Description, 
PlanCodes.Program 
ORDER BY 
GSFSContract_Detail.Insurance_Carrier, 
GSFSContract_Detail.Plan_Code, 
GSFSContract_Detail.Rate_Book, 
GSFSContract_Detail.New_Used







GO
