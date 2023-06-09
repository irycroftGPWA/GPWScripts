USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_04_UPDATE_GPWContracts]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_04_UPDATE_GPWContracts] AS

DECLARE @BegDate AS DATE
SET @BegDate = (SELECT BegDate FROM TBL_DBVALUES)
DECLARE @ValDate AS DATE
SET @ValDate = (SELECT ValDate FROM TBL_DBVALUES)

--   UPDATE GPWCancelCount Column
UPDATE GPWContracts
SET GPWCancelCount= 0
WHERE GPWContractCount=0
UPDATE GPWContracts
Set GPWCancelCount = 0
WHERE GPWCancelDate >@ValDate
UPDATE GPWContracts
SET GPWCancelCount = 1
WHERE GPWCancelDate <=@ValDate AND GPWContractCount<>0 
-- UPDATE GPWCancelQtr#
UPDATE GPWContracts
SET [GPWCancelQtr#] = (YEAR(GPWCancelDate) - YEAR(@valDate))*4 + CEILING(Cast((MONTH(GPWCancelDate) - MONTH(@valDate)) as float)/3) + 40
UPDATE GPWContracts
SET [GPWCancelQtr#] = 0
FROM GPWContracts 
WHERE [GPWCancelQtr#] IS NULL

GO
