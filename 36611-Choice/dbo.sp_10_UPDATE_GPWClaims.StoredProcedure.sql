USE [36611_202212_ChoiceHW]
GO
/****** Object:  StoredProcedure [dbo].[sp_10_UPDATE_GPWClaims]    Script Date: 5/18/2023 9:41:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_10_UPDATE_GPWClaims] AS
UPDATE GPWClaims 
SET GPWRelativeClaimQtr = Case 
				WHEN [GPWEffectiveQtr#] IS Null OR [GPWClaimQtr#] IS NULL
				THEN 0
				WHEN [GPWEffectiveQtr#] IS Not Null AND [GPWClaimQtr#] IS not NULL
				THEN [GPWClaimQtr#]-[GPWEffectiveQtr#]+1
			  End
FROM GPWClaims
UPDATE GPWClaims 
SET GPWActiveClaims = Case
			WHEN [GPWActiveClaimCount]=0
			THEN 0
			WHEN [GPWActiveClaimCount]<>0
			THEN [GPWClaims]
		  End
FROM GPWClaims
UPDATE GPWClaims 
SET GPWCancelClaims = Case
			WHEN [GPWCancelClaimCount]=0
			THEN 0
			WHEN [GPWCancelClaimCount]<>0
			THEN [GPWClaims]
		  End
FROM GPWClaims


IF OBJECT_ID('dbo.GPWClaimsByContract','U') IS NOT NULL
	DROP TABLE GPWClaimsByContract

	SELECT
	[Customer ID], GPWEffectiveDate,  --ACL 20190402 - updated to GPWEffectiveDate rather than StartDate
	SUM(GPWClaimCount) AS GPWClaimCount,
	SUM(GPWClaims) AS GPWClaims
	INTO GPWClaimsByContract
	FROM GPWClaims
	GROUP BY [Customer ID], GPWEffectiveDate
	
UPDATE GPWContracts
set GPWContracts.GPWClaimCount = GPWClaimsByContract.GPWClaimCount,
	GPWContracts.GPWClaims = GPWClaimsByContract.GPWClaims
FROM GPWClaimsByContract INNER JOIN
                      dbo.GPWContracts ON dbo.GPWClaimsByContract.[Customer ID] = dbo.GPWContracts.Cust
										AND dbo.GPWClaimsByContract.GPWEffectiveDate = dbo.GPWContracts.GPWEffectiveDate  --ACL 20190402 - updated to GPWEffectiveDate rather than StartDate

--IR added for new triangle segments differentiating between sales channel and plan
update GPWClaims
--set [GPW N/U/P] = case when [GPW Channel] = 'DTC' then [GPW N/U/P]
--  				   when [GPW Channel] = 'Real Estate' and [GPW N/U/P] <> 'Monthly' then 'RealEstate-'+[Plan] 
--				   when [GPW Channel] = 'Real Estate' and [GPW N/U/P] = 'Monthly' then 'RealEstate-Monthly' end 
set [GPW N/U/P] = case when [GPW Channel] = 'DTC' then [GPW N/U/P]
  				   when [GPW Channel] = 'Real Estate' and GPWContractType <> 'Monthly' then 'RealEstate-'+[GPWPlan] +'-'+[GPWRenewalFlag] --12/31/2019 AJD added Contract Type to split RealEstate segments 
				   when [GPW Channel] = 'Real Estate' and GPWContractType = 'Monthly' then 'RealEstate-Monthly' end 
GO
