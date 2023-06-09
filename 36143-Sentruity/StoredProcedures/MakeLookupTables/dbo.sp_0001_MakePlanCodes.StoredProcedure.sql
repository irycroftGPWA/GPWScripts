USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_0001_MakePlanCodes]    Script Date: 5/16/2023 9:50:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_0001_MakePlanCodes] AS
---****************************Do Not Delete************************************************
-- DROP TABLE code is commented out because manual updates would be lost if it accidently ran.

IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'PlanCodes')
	DROP TABLE PlanCodes

SELECT
C.Rate_Book,
C.New_Used,
C.Plan_Code,
C.Plan_Description,
C.Basis_Start_Date,
C.Basis_Start_Odometer,
P.Program
INTO PlanCodes
from RawDataPlans C left join [36143_Sentruity_202112_NewCarriers].dbo.PlanCodes P
On
C.[Rate_Book] = p.[Rate_Book] and 
C.[New_Used] = p.[New_Used] and 
C.[Plan_Code] = p.[Plan_Code] and 
C.[Plan_Description] = p.[Plan_Description] and 
C.[Basis_Start_Date] = p.[Basis_Start_Date] and 
C.[Basis_Start_Odometer] = p.[Basis_Start_Odometer]


GO
