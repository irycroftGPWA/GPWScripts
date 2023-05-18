USE [36611_202212_ChoiceHW]
GO
/****** Object:  StoredProcedure [dbo].[sp_09_UPDATE_GPWClaims]    Script Date: 5/18/2023 9:41:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_09_UPDATE_GPWClaims] AS

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
SET GPWClaims.GPWClaims =
		Case WHEN [GPWClaimCount]=0 THEN 0
			WHEN year(GPWClaimDate)<2015 then GPWAuthorized * 0.8099
			else GPWPaid end



GO
