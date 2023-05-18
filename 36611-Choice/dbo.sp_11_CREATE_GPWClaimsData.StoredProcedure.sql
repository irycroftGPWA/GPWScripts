USE [36611_202212_ChoiceHW]
GO
/****** Object:  StoredProcedure [dbo].[sp_11_CREATE_GPWClaimsData]    Script Date: 5/18/2023 9:41:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_11_CREATE_GPWClaimsData] AS

DECLARE @ValDate AS DATE
SET @ValDate = (SELECT ValDate FROM TBL_DBVALUES)

DECLARE @BegDate AS DATE
SET @BegDate = (SELECT BegDate FROM TBL_DBVALUES)

IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GPWClaimsData')
	DROP TABLE GPWClaimsData

/*MAKE SURE GPW MILES COLUMNS ARE FLOATS*/

CREATE TABLE [GPWClaimsData] (
	 [Customer ID] [nvarchar](255) NULL,
	 [Claim #] [nvarchar](255) NULL,
	 [Amount Authorized] [float] NULL,
	 [AmountPaid] [float] NULL,
	 [ibnr] [float] NULL

	,[GPWClaimDate] date
	,[GPWClaimQuarter] nvarchar(255)
	,[GPWClaimQtr#] int
	,[GPWRelativeClaimQtr] int
	,[GPWActiveClaimCount] int
	,[GPWCancelClaimCount] int
	,[GPWClaimCount] int
	,[GPWActiveClaims] float
	,[GPWCancelClaims] float 
	,[GPWClaims] float
	
	,[GPWCoverage1] nvarchar(255)
	,[GPWCoverage2] nvarchar(255)
	,[GPW N/U/P] nvarchar(255)
	,[GPW Channel] NVARCHAR(255)
	,[GPW Plan] nvarchar(255)
	,[GPWEffectiveDate] date
	,[GPWTermMonths] float
	,[GPWCancelDate] date
	,[GPWEffectiveQuarter] nvarchar(255)
	,[GPWEffectiveQtr#] int
	,[GPWEffectiveYear] int
	,[GPWExpireDate] date
	,[GPWCancelQuarter] nvarchar(255)
	,[GPWCancelQtr#] int
	,[GPWRelativeCancelQtr] int
	,[GPWFlatCancel] nvarchar(255)
	,[GPWContractCount] int
	,[GPWCancelCount] int
	
	,[GPWClaims1] float 
	,[GPWClaims2] float 
	,[GPWClaims3] float 
	,[GPWClaims4] float 
	,[GPWClaims5] float 
	,[GPWClaims6] float 
	,[GPWClaims7] float 
	,[GPWClaims8] float 
	,[GPWClaims9] float 
	,[GPWClaims10] float 
	,[GPWClaims11] float 
	,[GPWClaims12] float 
	,[GPWClaims13] float 
	,[GPWClaims14] float 
	,[GPWClaims15] float 
	,[GPWClaims16] float 
	,[GPWClaims17] float 
	,[GPWClaims18] float 
	,[GPWClaims19] float 
	,[GPWClaims20] float 
	,[GPWClaims21] float 
	,[GPWClaims22] float 
	,[GPWClaims23] float 
	,[GPWClaims24] float 
	,[GPWClaims25] float 
	,[GPWClaims26] float 
	,[GPWClaims27] float 
	,[GPWClaims28] float 
	,[GPWClaims29] float 
	,[GPWClaims30] float 
	,[GPWClaims31] float 
	,[GPWClaims32] float 
	,[GPWClaims33] float 
	,[GPWClaims34] float 
	,[GPWClaims35] float 
	,[GPWClaims36] float 
	,[GPWClaims37] float 
	,[GPWClaims38] float 
	,[GPWClaims39] float 
	,[GPWClaims40] float 
	,[GPWClaimCount1] int 
	,[GPWClaimCount2] int 
	,[GPWClaimCount3] int 
	,[GPWClaimCount4] int 
	,[GPWClaimCount5] int 
	,[GPWClaimCount6] int 
	,[GPWClaimCount7] int 
	,[GPWClaimCount8] int 
	,[GPWClaimCount9] int 
	,[GPWClaimCount10] int 
	,[GPWClaimCount11] int 
	,[GPWClaimCount12] int 
	,[GPWClaimCount13] int 
	,[GPWClaimCount14] int 
	,[GPWClaimCount15] int 
	,[GPWClaimCount16] int 
	,[GPWClaimCount17] int 
	,[GPWClaimCount18] int 
	,[GPWClaimCount19] int 
	,[GPWClaimCount20] int 
	,[GPWClaimCount21] int 
	,[GPWClaimCount22] int 
	,[GPWClaimCount23] int 
	,[GPWClaimCount24] int 
	,[GPWClaimCount25] int 
	,[GPWClaimCount26] int 
	,[GPWClaimCount27] int 
	,[GPWClaimCount28] int 
	,[GPWClaimCount29] int 
	,[GPWClaimCount30] int 
	,[GPWClaimCount31] int 
	,[GPWClaimCount32] int 
	,[GPWClaimCount33] int 
	,[GPWClaimCount34] int 
	,[GPWClaimCount35] int 
	,[GPWClaimCount36] int 
	,[GPWClaimCount37] int 
	,[GPWClaimCount38] int 
	,[GPWClaimCount39] int 
	,[GPWClaimCount40] int
)
INSERT INTO GPWClaimsData(
	 [Customer ID],
	 [Claim #],
	 [Amount Authorized],
	 [AmountPaid],
	 [ibnr]

	,[GPWClaimDate]
	,[GPWClaimQuarter]
	,[GPWClaimQtr#]
	,[GPWRelativeClaimQtr]
	,[GPWActiveClaimCount]
	,[GPWCancelClaimCount]
	,[GPWClaimCount]
	,[GPWActiveClaims]
	,[GPWCancelClaims] 
	,[GPWClaims]
	
	,[GPWCoverage1]
	,[GPWCoverage2]
	,[GPW N/U/P]
	,[GPW Channel]
	,[GPW Plan]
	,[GPWEffectiveDate]
	,[GPWTermMonths]
	,[GPWCancelDate]
	,[GPWEffectiveQuarter]
	,[GPWEffectiveQtr#]
	,[GPWEffectiveYear]
	,[GPWExpireDate]
	,[GPWCancelQuarter]
	,[GPWCancelQtr#]
	,[GPWRelativeCancelQtr]
	,[GPWFlatCancel]
	,[GPWContractCount]
	,[GPWCancelCount]
	
	,[GPWClaims1]
	,[GPWClaims2]
	,[GPWClaims3]
	,[GPWClaims4]
	,[GPWClaims5]
	,[GPWClaims6]
	,[GPWClaims7]
	,[GPWClaims8]
	,[GPWClaims9]
	,[GPWClaims10]
	,[GPWClaims11]
	,[GPWClaims12]
	,[GPWClaims13]
	,[GPWClaims14]
	,[GPWClaims15]
	,[GPWClaims16]
	,[GPWClaims17]
	,[GPWClaims18]
	,[GPWClaims19]
	,[GPWClaims20]
	,[GPWClaims21]
	,[GPWClaims22]
	,[GPWClaims23]
	,[GPWClaims24]
	,[GPWClaims25]
	,[GPWClaims26]
	,[GPWClaims27]
	,[GPWClaims28]
	,[GPWClaims29]
	,[GPWClaims30]
	,[GPWClaims31]
	,[GPWClaims32]
	,[GPWClaims33]
	,[GPWClaims34]
	,[GPWClaims35]
	,[GPWClaims36]
	,[GPWClaims37]
	,[GPWClaims38]
	,[GPWClaims39]
	,[GPWClaims40]
	,[GPWClaimCount1]
	,[GPWClaimCount2]
	,[GPWClaimCount3]
	,[GPWClaimCount4]
	,[GPWClaimCount5]
	,[GPWClaimCount6]
	,[GPWClaimCount7]
	,[GPWClaimCount8]
	,[GPWClaimCount9]
	,[GPWClaimCount10]
	,[GPWClaimCount11]
	,[GPWClaimCount12]
	,[GPWClaimCount13]
	,[GPWClaimCount14]
	,[GPWClaimCount15]
	,[GPWClaimCount16]
	,[GPWClaimCount17]
	,[GPWClaimCount18]
	,[GPWClaimCount19]
	,[GPWClaimCount20]
	,[GPWClaimCount21]
	,[GPWClaimCount22]
	,[GPWClaimCount23]
	,[GPWClaimCount24]
	,[GPWClaimCount25]
	,[GPWClaimCount26]
	,[GPWClaimCount27]
	,[GPWClaimCount28]
	,[GPWClaimCount29]
	,[GPWClaimCount30]
	,[GPWClaimCount31]
	,[GPWClaimCount32]
	,[GPWClaimCount33]
	,[GPWClaimCount34]
	,[GPWClaimCount35]
	,[GPWClaimCount36]
	,[GPWClaimCount37]
	,[GPWClaimCount38]
	,[GPWClaimCount39]
	,[GPWClaimCount40]
	)
SELECT 
	 [Customer ID] as [Customer ID],
	 [Claim #] as [Claim #],
	 [Amount Authorized] as [Amount Authorized],
	 [AmountPaid] as [Amount Paid],
	 [ibnr] as [ibnr]
 
	,[GPWClaimDate] AS [GPWClaimDate]
	,[GPWClaimQuarter] AS [GPWClaimQuarter]
	,[GPWClaimQtr#] AS [GPWClaimQtr#]
	,[GPWRelativeClaimQtr] AS [GPWRelativeClaimQtr]
	,[GPWActiveClaimCount] AS [GPWActiveClaimCount]
	,[GPWCancelClaimCount] AS [GPWCancelClaimCount]
	,[GPWClaimCount] AS [GPWClaimCount]
	,[GPWActiveClaims] AS [GPWActiveClaims]
	,[GPWCancelClaims]  AS [GPWCancelClaims] 
	,[GPWClaims] AS [GPWClaims]

	,[GPWCoverage1] AS [GPWCoverage1]
	,[GPWCoverage2] AS [GPWCoverage2]
	,[GPW N/U/P] AS [GPW N/U/P]
	,[GPW Channel] as [GPW Channel]
	,[GPWPlan] as [GPW Plan]
	,[GPWEffectiveDate] AS [GPWEffectiveDate]
	,[GPWTermMonths] AS [GPWTermMonths]
	,[GPWCancelDate] AS [GPWCancelDate]
	,[GPWEffectiveQuarter] AS [GPWEffectiveQuarter]
	,[GPWEffectiveQtr#] AS [GPWEffectiveQtr#]
	,[GPWEffectiveYear] AS [GPWEffectiveYear]
	,[GPWExpireDate] AS [GPWExpireDate]
	,[GPWCancelQuarter] AS [GPWCancelQuarter]
	,[GPWCancelQtr#] AS [GPWCancelQtr#]
	,[GPWRelativeCancelQtr] AS [GPWRelativeCancelQtr]
	,[GPWFlatCancel] AS [GPWFlatCancel]
	,[GPWContractCount] AS [GPWContractCount]
	,[GPWCancelCount] AS [GPWCancelCount]
	
	,0 AS GPWClaims1 
	,0 AS GPWClaims2 
	,0 AS GPWClaims3 
	,0 AS GPWClaims4 
	,0 AS GPWClaims5 
	,0 AS GPWClaims6 
	,0 AS GPWClaims7 
	,0 AS GPWClaims8 
	,0 AS GPWClaims9 
	,0 AS GPWClaims10 
	,0 AS GPWClaims11 
	,0 AS GPWClaims12 
	,0 AS GPWClaims13 
	,0 AS GPWClaims14 
	,0 AS GPWClaims15 
	,0 AS GPWClaims16 
	,0 AS GPWClaims17 
	,0 AS GPWClaims18 
	,0 AS GPWClaims19 
	,0 AS GPWClaims20 
	,0 AS GPWClaims21 
	,0 AS GPWClaims22 
	,0 AS GPWClaims23 
	,0 AS GPWClaims24 
	,0 AS GPWClaims25 
	,0 AS GPWClaims26 
	,0 AS GPWClaims27 
	,0 AS GPWClaims28 
	,0 AS GPWClaims29 
	,0 AS GPWClaims30 
	,0 AS GPWClaims31 
	,0 AS GPWClaims32 
	,0 AS GPWClaims33 
	,0 AS GPWClaims34 
	,0 AS GPWClaims35 
	,0 AS GPWClaims36 
	,0 AS GPWClaims37 
	,0 AS GPWClaims38 
	,0 AS GPWClaims39 
	,0 AS GPWClaims40 
	,0 AS GPWClaimCount1 
	,0 AS GPWClaimCount2 
	,0 AS GPWClaimCount3 
	,0 AS GPWClaimCount4 
	,0 AS GPWClaimCount5 
	,0 AS GPWClaimCount6 
	,0 AS GPWClaimCount7 
	,0 AS GPWClaimCount8 
	,0 AS GPWClaimCount9 
	,0 AS GPWClaimCount10 
	,0 AS GPWClaimCount11 
	,0 AS GPWClaimCount12 
	,0 AS GPWClaimCount13 
	,0 AS GPWClaimCount14 
	,0 AS GPWClaimCount15
	,0 AS GPWClaimCount16 
	,0 AS GPWClaimCount17 
	,0 AS GPWClaimCount18 
	,0 AS GPWClaimCount19 
	,0 AS GPWClaimCount20 
	,0 AS GPWClaimCount21 
	,0 AS GPWClaimCount22 
	,0 AS GPWClaimCount23 
	,0 AS GPWClaimCount24 
	,0 AS GPWClaimCount25 
	,0 AS GPWClaimCount26 
	,0 AS GPWClaimCount27
	,0 AS GPWClaimCount28 
	,0 AS GPWClaimCount29 
	,0 AS GPWClaimCount30 
	,0 AS GPWClaimCount31 
	,0 AS GPWClaimCount32 
	,0 AS GPWClaimCount33 
	,0 AS GPWClaimCount34 
	,0 AS GPWClaimCount35 
	,0 AS GPWClaimCount36 
	,0 AS GPWClaimCount37 
	,0 AS GPWClaimCount38 
	,0 AS GPWClaimCount39 
	,0 AS GPWClaimCount40 

FROM GPWClaims

WHERE (GPWClaimDate <= @ValDate) and (GPWClaimDate>=@begdate)
AND (GPWRelativeClaimQtr > 0) 
AND (GPWClaimCount = 1) 
--AND (GPWClaims > 0)  -- We need the claim counts to be authorized, GPWClaims to be Paid -- turned off to not lose claim counts.
AND (GPWEffectiveDate <= @ValDate) and (GPWEffectiveDate>=@begdate)
AND (GPWTermMonths > 0) 
And (GPWTermMonths < 181)  --ACL changed to 180
--AND (GPWContractCount = 1) 
--AND (GPWActiveReserve > 0 OR GPWCancelReserve > 0)
GO
