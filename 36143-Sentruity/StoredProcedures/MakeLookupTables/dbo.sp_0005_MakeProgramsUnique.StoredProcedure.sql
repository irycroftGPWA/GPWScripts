USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_0005_MakeProgramsUnique]    Script Date: 5/16/2023 9:50:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[sp_0005_MakeProgramsUnique] AS


IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'ProgramsUnique')
	DROP TABLE ProgramsUnique


SELECT 
ltrim(rtrim(Insurance_Carrier)) as Insurance_Carrier, 
ltrim(rtrim(Plan_Code)) as Plan_Code, 
ltrim(rtrim(New_Used)) as New_Used, 
ltrim(rtrim(Rate_Book)) as Rate_Book, 
ltrim(rtrim(Program)) as Program, 
SUM([Count]) AS Count
INTO ProgramsUnique
FROM Programs
GROUP BY 
ltrim(rtrim(Insurance_Carrier)), 
ltrim(rtrim(Plan_Code)), 
ltrim(rtrim(New_Used)), 
ltrim(rtrim(Rate_Book)), 
ltrim(rtrim(Program)) 
ORDER BY 
Insurance_Carrier, 
Plan_Code, 
New_Used, 
Rate_Book, 
Program


GO
