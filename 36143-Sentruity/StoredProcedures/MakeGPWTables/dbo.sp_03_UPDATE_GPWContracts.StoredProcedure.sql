USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_03_UPDATE_GPWContracts]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_03_UPDATE_GPWContracts] AS

DECLARE @BegDate AS DATE
SET @BegDate = (SELECT BegDate FROM TBL_DBVALUES)
DECLARE @ValDate AS DATE
SET @ValDate = (SELECT ValDate FROM TBL_DBVALUES)

UPDATE GPWContracts 
SET 
GPWContracts.GPWContractCount = 
(Case	When [GPWEffectiveDate]>@ValDate
	Then '0'
	When GPWTerm<1
	Then '0' 
--COMMENT OUT THE FLAT CANCELS EXCLUSION FOR PURPOSES OF PROVIDING GS RE REFUND TRIANGLES TO CALEB
	When [GPWFlatCancel]='F'
	Then '0'
	Else '1'
End)
FROM GPWContracts
--   UPDATE GPWEffectiveQtr# Column
UPDATE GPWContracts
SET GPWEffectiveQtr# = (YEAR(GPWEffectiveDate) - YEAR(@valDate))*4 + CEILING(Cast((MONTH(GPWEffectiveDate) - MONTH(@valDate)) as float)/3) + 40
GO
