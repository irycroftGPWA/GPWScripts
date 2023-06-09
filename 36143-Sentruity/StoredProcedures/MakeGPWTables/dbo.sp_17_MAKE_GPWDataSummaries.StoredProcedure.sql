USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_17_MAKE_GPWDataSummaries]    Script Date: 5/16/2023 11:04:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_17_MAKE_GPWDataSummaries] AS

-----------------------------------------RRG - First Dollar RETAINED-----------------------------------------
IF EXISTS (SELECT name FROM sysobjects
WHERE name = 'GPWDataSummary')
DROP TABLE GPWDataSummary
SELECT
GPWContractDataSummary.SQLCat1,
GPWContractDataSummary.SQLCat2,
GPWContractDataSummary.SQLCat3,
GPWContractDataSummary.GPWAgg_CCC,
GPWContractDataSummary.GPWAgg_GAP,
GPWContractDataSummary.GPWAgg_LTW,
GPWContractDataSummary.GPWAgg_MTNG,
GPWContractDataSummary.GPWAgg_SDC,
GPWContractDataSummary.GPWAgg_SNV,
GPWContractDataSummary.GPWAgg_TEC,
GPWContractDataSummary.GPWAgg_VSC_MBI,
GPWContractDataSummary.GPWAgg_ANCL,
GPWContractDataSummary.GPWCoverage,
GPWContractDataSummary.[GPW N/U/P] AS [N/U/P],
GPWContractDataSummary.GPWTermMonths AS [Term Months],
GPWContractDataSummary.GPWEffectiveQuarter AS [Effective Quarter],
GPWContractDataSummary.SumOfGPWContractCount AS [Contract Count],
GPWContractDataSummary.SumOfGPWCancelCount AS [Cancel Count],
GPWContractDataSummary.SumOfGPWActiveReserve AS [Active Rx],
GPWContractDataSummary.SumOfGPWCancelReserve AS [Cancel Rx],
GPWContractDataSummary.SumOfGPWMMEarned AS [MM Earned],
GPWClaimsDataSummary.SumOfGPWActiveClaimCount AS [Active Claim Count],
GPWClaimsDataSummary.SumOfGPWCancelClaimCount AS [Cancel Claim Count],
GPWClaimsDataSummary.SumOfGPWClaimCount AS [Claim Count],
GPWClaimsDataSummary.SumOfGPWActiveClaims AS [Active Claims],
GPWClaimsDataSummary.SumOfGPWCancelClaims AS [Cancel Claims],
GPWClaimsDataSummary.SumOfGPWClaims AS Claims,
GPWClaimsDataSummary.SumOfGPWClaims1 AS ClaimsQtr1,
GPWClaimsDataSummary.SumOfGPWClaims2 AS ClaimsQtr2,
GPWClaimsDataSummary.SumOfGPWClaims3 AS ClaimsQtr3,
GPWClaimsDataSummary.SumOfGPWClaims4 AS ClaimsQtr4,
GPWClaimsDataSummary.SumOfGPWClaims5 AS ClaimsQtr5,
GPWClaimsDataSummary.SumOfGPWClaims6 AS ClaimsQtr6,
GPWClaimsDataSummary.SumOfGPWClaims7 AS ClaimsQtr7,
GPWClaimsDataSummary.SumOfGPWClaims8 AS ClaimsQtr8,
GPWClaimsDataSummary.SumOfGPWClaims9 AS ClaimsQtr9,
GPWClaimsDataSummary.SumOfGPWClaims10 AS ClaimsQtr10,
GPWClaimsDataSummary.SumOfGPWClaims11 AS ClaimsQtr11,
GPWClaimsDataSummary.SumOfGPWClaims12 AS ClaimsQtr12,
GPWClaimsDataSummary.SumOfGPWClaims13 AS ClaimsQtr13,
GPWClaimsDataSummary.SumOfGPWClaims14 AS ClaimsQtr14,
GPWClaimsDataSummary.SumOfGPWClaims15 AS ClaimsQtr15,
GPWClaimsDataSummary.SumOfGPWClaims16 AS ClaimsQtr16,
GPWClaimsDataSummary.SumOfGPWClaims17 AS ClaimsQtr17,
GPWClaimsDataSummary.SumOfGPWClaims18 AS ClaimsQtr18,
GPWClaimsDataSummary.SumOfGPWClaims19 AS ClaimsQtr19,
GPWClaimsDataSummary.SumOfGPWClaims20 AS ClaimsQtr20,
GPWClaimsDataSummary.SumOfGPWClaims21 AS ClaimsQtr21,
GPWClaimsDataSummary.SumOfGPWClaims22 AS ClaimsQtr22,
GPWClaimsDataSummary.SumOfGPWClaims23 AS ClaimsQtr23,
GPWClaimsDataSummary.SumOfGPWClaims24 AS ClaimsQtr24,
GPWClaimsDataSummary.SumOfGPWClaims25 AS ClaimsQtr25,
GPWClaimsDataSummary.SumOfGPWClaims26 AS ClaimsQtr26,
GPWClaimsDataSummary.SumOfGPWClaims27 AS ClaimsQtr27,
GPWClaimsDataSummary.SumOfGPWClaims28 AS ClaimsQtr28,
GPWClaimsDataSummary.SumOfGPWClaims29 AS ClaimsQtr29,
GPWClaimsDataSummary.SumOfGPWClaims30 AS ClaimsQtr30,
GPWClaimsDataSummary.SumOfGPWClaims31 AS ClaimsQtr31,
GPWClaimsDataSummary.SumOfGPWClaims32 AS ClaimsQtr32,
GPWClaimsDataSummary.SumOfGPWClaims33 AS ClaimsQtr33,
GPWClaimsDataSummary.SumOfGPWClaims34 AS ClaimsQtr34,
GPWClaimsDataSummary.SumOfGPWClaims35 AS ClaimsQtr35,
GPWClaimsDataSummary.SumOfGPWClaims36 AS ClaimsQtr36,
GPWClaimsDataSummary.SumOfGPWClaims37 AS ClaimsQtr37,
GPWClaimsDataSummary.SumOfGPWClaims38 AS ClaimsQtr38,
GPWClaimsDataSummary.SumOfGPWClaims39 AS ClaimsQtr39,
GPWClaimsDataSummary.SumOfGPWClaims40 AS ClaimsQtr40,
GPWClaimsDataSummary.SumOfGPWClaimCount1 AS ClaimCountQtr1,
GPWClaimsDataSummary.SumOfGPWClaimCount2 AS ClaimCountQtr2,
GPWClaimsDataSummary.SumOfGPWClaimCount3 AS ClaimCountQtr3,
GPWClaimsDataSummary.SumOfGPWClaimCount4 AS ClaimCountQtr4,
GPWClaimsDataSummary.SumOfGPWClaimCount5 AS ClaimCountQtr5,
GPWClaimsDataSummary.SumOfGPWClaimCount6 AS ClaimCountQtr6,
GPWClaimsDataSummary.SumOfGPWClaimCount7 AS ClaimCountQtr7,
GPWClaimsDataSummary.SumOfGPWClaimCount8 AS ClaimCountQtr8,
GPWClaimsDataSummary.SumOfGPWClaimCount9 AS ClaimCountQtr9,
GPWClaimsDataSummary.SumOfGPWClaimCount10 AS ClaimCountQtr10,
GPWClaimsDataSummary.SumOfGPWClaimCount11 AS ClaimCountQtr11,
GPWClaimsDataSummary.SumOfGPWClaimCount12 AS ClaimCountQtr12,
GPWClaimsDataSummary.SumOfGPWClaimCount13 AS ClaimCountQtr13,
GPWClaimsDataSummary.SumOfGPWClaimCount14 AS ClaimCountQtr14,
GPWClaimsDataSummary.SumOfGPWClaimCount15 AS ClaimCountQtr15,
GPWClaimsDataSummary.SumOfGPWClaimCount16 AS ClaimCountQtr16,
GPWClaimsDataSummary.SumOfGPWClaimCount17 AS ClaimCountQtr17,
GPWClaimsDataSummary.SumOfGPWClaimCount18 AS ClaimCountQtr18,
GPWClaimsDataSummary.SumOfGPWClaimCount19 AS ClaimCountQtr19,
GPWClaimsDataSummary.SumOfGPWClaimCount20 AS ClaimCountQtr20,
GPWClaimsDataSummary.SumOfGPWClaimCount21 AS ClaimCountQtr21,
GPWClaimsDataSummary.SumOfGPWClaimCount22 AS ClaimCountQtr22,
GPWClaimsDataSummary.SumOfGPWClaimCount23 AS ClaimCountQtr23,
GPWClaimsDataSummary.SumOfGPWClaimCount24 AS ClaimCountQtr24,
GPWClaimsDataSummary.SumOfGPWClaimCount25 AS ClaimCountQtr25,
GPWClaimsDataSummary.SumOfGPWClaimCount26 AS ClaimCountQtr26,
GPWClaimsDataSummary.SumOfGPWClaimCount27 AS ClaimCountQtr27,
GPWClaimsDataSummary.SumOfGPWClaimCount28 AS ClaimCountQtr28,
GPWClaimsDataSummary.SumOfGPWClaimCount29 AS ClaimCountQtr29,
GPWClaimsDataSummary.SumOfGPWClaimCount30 AS ClaimCountQtr30,
GPWClaimsDataSummary.SumOfGPWClaimCount31 AS ClaimCountQtr31,
GPWClaimsDataSummary.SumOfGPWClaimCount32 AS ClaimCountQtr32,
GPWClaimsDataSummary.SumOfGPWClaimCount33 AS ClaimCountQtr33,
GPWClaimsDataSummary.SumOfGPWClaimCount34 AS ClaimCountQtr34,
GPWClaimsDataSummary.SumOfGPWClaimCount35 AS ClaimCountQtr35,
GPWClaimsDataSummary.SumOfGPWClaimCount36 AS ClaimCountQtr36,
GPWClaimsDataSummary.SumOfGPWClaimCount37 AS ClaimCountQtr37,
GPWClaimsDataSummary.SumOfGPWClaimCount38 AS ClaimCountQtr38,
GPWClaimsDataSummary.SumOfGPWClaimCount39 AS ClaimCountQtr39,
GPWClaimsDataSummary.SumOfGPWClaimCount40 AS ClaimCountQtr40,
GPWContractDataSummary.SumOfGPWCancelCount1 AS CancelCountQtr1,
GPWContractDataSummary.SumOfGPWCancelCount2 AS CancelCountQtr2,
GPWContractDataSummary.SumOfGPWCancelCount3 AS CancelCountQtr3,
GPWContractDataSummary.SumOfGPWCancelCount4 AS CancelCountQtr4,
GPWContractDataSummary.SumOfGPWCancelCount5 AS CancelCountQtr5,
GPWContractDataSummary.SumOfGPWCancelCount6 AS CancelCountQtr6,
GPWContractDataSummary.SumOfGPWCancelCount7 AS CancelCountQtr7,
GPWContractDataSummary.SumOfGPWCancelCount8 AS CancelCountQtr8,
GPWContractDataSummary.SumOfGPWCancelCount9 AS CancelCountQtr9,
GPWContractDataSummary.SumOfGPWCancelCount10 AS CancelCountQtr10,
GPWContractDataSummary.SumOfGPWCancelCount11 AS CancelCountQtr11,
GPWContractDataSummary.SumOfGPWCancelCount12 AS CancelCountQtr12,
GPWContractDataSummary.SumOfGPWCancelCount13 AS CancelCountQtr13,
GPWContractDataSummary.SumOfGPWCancelCount14 AS CancelCountQtr14,
GPWContractDataSummary.SumOfGPWCancelCount15 AS CancelCountQtr15,
GPWContractDataSummary.SumOfGPWCancelCount16 AS CancelCountQtr16,
GPWContractDataSummary.SumOfGPWCancelCount17 AS CancelCountQtr17,
GPWContractDataSummary.SumOfGPWCancelCount18 AS CancelCountQtr18,
GPWContractDataSummary.SumOfGPWCancelCount19 AS CancelCountQtr19,
GPWContractDataSummary.SumOfGPWCancelCount20 AS CancelCountQtr20,
GPWContractDataSummary.SumOfGPWCancelCount21 AS CancelCountQtr21,
GPWContractDataSummary.SumOfGPWCancelCount22 AS CancelCountQtr22,
GPWContractDataSummary.SumOfGPWCancelCount23 AS CancelCountQtr23,
GPWContractDataSummary.SumOfGPWCancelCount24 AS CancelCountQtr24,
GPWContractDataSummary.SumOfGPWCancelCount25 AS CancelCountQtr25,
GPWContractDataSummary.SumOfGPWCancelCount26 AS CancelCountQtr26,
GPWContractDataSummary.SumOfGPWCancelCount27 AS CancelCountQtr27,
GPWContractDataSummary.SumOfGPWCancelCount28 AS CancelCountQtr28,
GPWContractDataSummary.SumOfGPWCancelCount29 AS CancelCountQtr29,
GPWContractDataSummary.SumOfGPWCancelCount30 AS CancelCountQtr30,
GPWContractDataSummary.SumOfGPWCancelCount31 AS CancelCountQtr31,
GPWContractDataSummary.SumOfGPWCancelCount32 AS CancelCountQtr32,
GPWContractDataSummary.SumOfGPWCancelCount33 AS CancelCountQtr33,
GPWContractDataSummary.SumOfGPWCancelCount34 AS CancelCountQtr34,
GPWContractDataSummary.SumOfGPWCancelCount35 AS CancelCountQtr35,
GPWContractDataSummary.SumOfGPWCancelCount36 AS CancelCountQtr36,
GPWContractDataSummary.SumOfGPWCancelCount37 AS CancelCountQtr37,
GPWContractDataSummary.SumOfGPWCancelCount38 AS CancelCountQtr38,
GPWContractDataSummary.SumOfGPWCancelCount39 AS CancelCountQtr39,
GPWContractDataSummary.SumOfGPWCancelCount40  AS CancelCountQtr40,
0 AS [MM Earned Qtr End],
GPWContractDataSummary.SumOfGPWCancelRx1  AS CancelRxQtr1,
GPWContractDataSummary.SumOfGPWCancelRx2  AS CancelRxQtr2,
GPWContractDataSummary.SumOfGPWCancelRx3  AS CancelRxQtr3,
GPWContractDataSummary.SumOfGPWCancelRx4  AS CancelRxQtr4,
GPWContractDataSummary.SumOfGPWCancelRx5  AS CancelRxQtr5,
GPWContractDataSummary.SumOfGPWCancelRx6  AS CancelRxQtr6,
GPWContractDataSummary.SumOfGPWCancelRx7  AS CancelRxQtr7,
GPWContractDataSummary.SumOfGPWCancelRx8  AS CancelRxQtr8,
GPWContractDataSummary.SumOfGPWCancelRx9  AS CancelRxQtr9,
GPWContractDataSummary.SumOfGPWCancelRx10  AS CancelRxQtr10,
GPWContractDataSummary.SumOfGPWCancelRx11  AS CancelRxQtr11,
GPWContractDataSummary.SumOfGPWCancelRx12  AS CancelRxQtr12,
GPWContractDataSummary.SumOfGPWCancelRx13  AS CancelRxQtr13,
GPWContractDataSummary.SumOfGPWCancelRx14  AS CancelRxQtr14,
GPWContractDataSummary.SumOfGPWCancelRx15  AS CancelRxQtr15,
GPWContractDataSummary.SumOfGPWCancelRx16  AS CancelRxQtr16,
GPWContractDataSummary.SumOfGPWCancelRx17  AS CancelRxQtr17,
GPWContractDataSummary.SumOfGPWCancelRx18  AS CancelRxQtr18,
GPWContractDataSummary.SumOfGPWCancelRx19  AS CancelRxQtr19,
GPWContractDataSummary.SumOfGPWCancelRx20  AS CancelRxQtr20,
GPWContractDataSummary.SumOfGPWCancelRx21  AS CancelRxQtr21,
GPWContractDataSummary.SumOfGPWCancelRx22  AS CancelRxQtr22,
GPWContractDataSummary.SumOfGPWCancelRx23  AS CancelRxQtr23,
GPWContractDataSummary.SumOfGPWCancelRx24  AS CancelRxQtr24,
GPWContractDataSummary.SumOfGPWCancelRx25  AS CancelRxQtr25,
GPWContractDataSummary.SumOfGPWCancelRx26  AS CancelRxQtr26,
GPWContractDataSummary.SumOfGPWCancelRx27  AS CancelRxQtr27,
GPWContractDataSummary.SumOfGPWCancelRx28  AS CancelRxQtr28,
GPWContractDataSummary.SumOfGPWCancelRx29  AS CancelRxQtr29,
GPWContractDataSummary.SumOfGPWCancelRx30  AS CancelRxQtr30,
GPWContractDataSummary.SumOfGPWCancelRx31  AS CancelRxQtr31,
GPWContractDataSummary.SumOfGPWCancelRx32  AS CancelRxQtr32,
GPWContractDataSummary.SumOfGPWCancelRx33  AS CancelRxQtr33,
GPWContractDataSummary.SumOfGPWCancelRx34  AS CancelRxQtr34,
GPWContractDataSummary.SumOfGPWCancelRx35  AS CancelRxQtr35,
GPWContractDataSummary.SumOfGPWCancelRx36  AS CancelRxQtr36,
GPWContractDataSummary.SumOfGPWCancelRx37  AS CancelRxQtr37,
GPWContractDataSummary.SumOfGPWCancelRx38  AS CancelRxQtr38,
GPWContractDataSummary.SumOfGPWCancelRx39  AS CancelRxQtr39,
GPWContractDataSummary.SumOfGPWCancelRx40  AS CancelRxQtr40

INTO GPWDataSummary
FROM GPWContractDataSummary LEFT JOIN GPWClaimsDataSummary 
ON (GPWContractDataSummary.GPWEffectiveQuarter = GPWClaimsDataSummary.GPWEffectiveQuarter) 
AND (GPWContractDataSummary.GPWTermMonths = GPWClaimsDataSummary.GPWTermMonths) 
AND (GPWContractDataSummary.[GPW N/U/P] = GPWClaimsDataSummary.[GPW N/U/P])
AND ( GPWContractDataSummary.GPWCoverage = GPWClaimsDataSummary.GPWCoverage)
AND (GPWContractDataSummary.SQLCat1 = GPWClaimsDataSummary.SQLCat1)
AND (GPWContractDataSummary.SQLCat2 = GPWClaimsDataSummary.SQLCat2)
AND (GPWContractDataSummary.SQLCat3 = GPWClaimsDataSummary.SQLCat3)
AND (GPWContractDataSummary.GPWAgg_CCC = GPWClaimsDataSummary.GPWAgg_CCC)
AND (GPWContractDataSummary.GPWAgg_GAP = GPWClaimsDataSummary.GPWAgg_GAP)
AND (GPWContractDataSummary.GPWAgg_LTW = GPWClaimsDataSummary.GPWAgg_LTW)
AND (GPWContractDataSummary.GPWAgg_MTNG = GPWClaimsDataSummary.GPWAgg_MTNG)
AND (GPWContractDataSummary.GPWAgg_SDC = GPWClaimsDataSummary.GPWAgg_SDC)
AND (GPWContractDataSummary.GPWAgg_SNV = GPWClaimsDataSummary.GPWAgg_SNV)
AND (GPWContractDataSummary.GPWAgg_TEC = GPWClaimsDataSummary.GPWAgg_TEC)
AND (GPWContractDataSummary.GPWAgg_VSC_MBI = GPWClaimsDataSummary.GPWAgg_VSC_MBI)
AND (GPWContractDataSummary.GPWAgg_ANCL = GPWClaimsDataSummary.GPWAgg_ANCL)
GO
