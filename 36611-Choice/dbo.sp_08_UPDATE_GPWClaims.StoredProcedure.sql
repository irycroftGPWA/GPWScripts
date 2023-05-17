USE [36611_202212_ChoiceHW]
GO
/****** Object:  StoredProcedure [dbo].[sp_08_UPDATE_GPWClaims]    Script Date: 5/17/2023 3:20:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_08_UPDATE_GPWClaims] AS

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

--For 12/31/2018 analysis, a check on amountpaid < 0 was added to catch negative paid claims with positive gpwauthorized.

UPDATE GPWClaims
SET GPWClaimCount = (CASE
		WHEN /*[GPWContractCount] = 0 Or*/ [GPWClaimDate] > @ValDate  Or GPWAuthorized <= 0 
		--IR: AmountPaid < 0 included as these are vendor credits that may offset payments
		-- or AmountPaid < 0
		THEN 0
		ELSE 1
		END)
FROM GPWClaims

--IR added 12/31/18 to allow joins on null plan values
update GPWClaims
set [Plan] = CASE when [Plan] is null then 'NULL' else [Plan] end	
GO
