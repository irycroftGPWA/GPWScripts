USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_09_UPDATE_GPWClaims]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_09_UPDATE_GPWClaims] AS

DECLARE @BegDate AS DATE
SET @BegDate = (SELECT BegDate FROM TBL_DBVALUES)
DECLARE @ValDate AS DATE
SET @ValDate = (SELECT ValDate FROM TBL_DBVALUES)

UPDATE GPWClaims 
SET GPWClaimQuarter = (Case
		WHEN Month([GPWClaimDate]) = 1
		THEN '1.' + Cast(Year([GPWClaimDate]) as varchar) + '.'
		WHEN Month([GPWClaimDate]) = 2 
		THEN '1.' + Cast(Year([GPWClaimDate]) as varchar) + '.' 
		WHEN Month([GPWClaimDate]) = 3 
		THEN '1.' + Cast(Year([GPWClaimDate]) as varchar) + '.' 
		WHEN Month([GPWClaimDate]) = 4 
		THEN '2.' + Cast(Year([GPWClaimDate]) as varchar) + '.' 
		WHEN Month([GPWClaimDate]) = 5
		THEN '2.' + Cast(Year([GPWClaimDate]) as varchar) + '.' 
		WHEN Month([GPWClaimDate]) = 6 
		THEN '2.' + Cast(Year([GPWClaimDate]) as varchar) + '.' 
		WHEN Month([GPWClaimDate]) = 7 
		THEN '3.' + Cast(Year([GPWClaimDate]) as varchar) + '.' 
		WHEN Month([GPWClaimDate]) = 8 
		THEN '3.' + Cast(Year([GPWClaimDate]) as varchar) + '.' 
		WHEN Month([GPWClaimDate]) = 9
		THEN '3.' + Cast(Year([GPWClaimDate]) as varchar) + '.' 
		WHEN Month([GPWClaimDate]) = 10 
		THEN '4.' + Cast(Year([GPWClaimDate]) as varchar) + '.' 
		WHEN Month([GPWClaimDate]) = 11 
		THEN '4.' + Cast(Year([GPWClaimDate]) as varchar) + '.' 
		WHEN Month([GPWClaimDate]) = 12 
		THEN '4.' + Cast(Year([GPWClaimDate]) as varchar) + '.' 
	End)
FROM GPWClaims
UPDATE GPWClaims
SET GPWClaimCount = (CASE
		WHEN [GPWContractCount]=0 Or [GPWClaimDate]>@ValDate Or [Amount_Paid]<=0 Or [Amount_Paid] is null
		THEN 0
		ELSE 1
		END)
FROM GPWClaims

-----------
--Update GPWCLaims 
--Set GPWClaimDate = Case when GPWAgg_GAP = 'y' then Date_Claim_Detail_Paid else GPWClaimDate end ---GAP claims tri on paid basis
GO
