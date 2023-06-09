USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_10_UPDATE_GPWClaims]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_10_UPDATE_GPWClaims] AS

DECLARE @BegDate AS DATE
SET @BegDate = (SELECT BegDate FROM TBL_DBVALUES)
DECLARE @ValDate AS DATE
SET @ValDate = (SELECT ValDate FROM TBL_DBVALUES)

UPDATE GPWClaims 
SET GPWClaims.[GPWClaimQtr#] = (YEAR(GPWClaimDate) - YEAR(@valDate))*4 + CEILING(cast((MONTH(GPWClaimDate) - MONTH(@valDate)) as float)/3) + 40

UPDATE GPWClaims 
SET GPWClaims.GPWActiveClaimCount = (Case
			WHEN [GPWCancelCount]=0
			THEN [GPWClaimCount]
			WHEN [GPWCancelCount] <>0
			THEN 0
				END)
FROM GPWClaims
UPDATE GPWClaims 
SET GPWClaims.GPWCancelClaimCount = (Case
			WHEN [GPWCancelCount]=0
			THEN 0
			WHEN [GPWCancelCount] <> 0
			THEN [GPWClaimCount]
				END)
FROM GPWClaims
UPDATE GPWClaims 
SET GPWClaims.GPWClaims = (Case
			WHEN [GPWClaimCount]=0
			THEN 0
			WHEN [GPWClaimCount] <> 0
			THEN [Amount_Paid]
				END)
FROM GPWClaims

GO
