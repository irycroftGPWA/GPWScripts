USE [36611_202212_ChoiceHW]
GO
/****** Object:  StoredProcedure [dbo].[sp_16z_CREATE_GPWDataSummaryQtrTest]    Script Date: 5/18/2023 9:41:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_16z_CREATE_GPWDataSummaryQtrTest] AS
IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GPWDataSummaryQtrTest')
	DROP TABLE GPWDataSummaryQtrTest
SELECT
GPWContractDataSummary.[GPW N/U/P]+'_'+left(gpwcontractdatasummary.GPWEffectiveQuarter,1)  as [N/U/P]
,GPWContractDataSummary.[GPW Channel] as [GPW Channel]
,GPWContractDataSummary.[GPW Plan] as [GPW Plan]
,GPWContractDataSummary.GPWTermMonths as [Term Months]
,GPWContractDataSummary.GPWEffectiveQuarter  as [Effective Quarter]
,GPWContractDataSummary.SumOfGPWContractCount  as [Contract Count]
,GPWContractDataSummary.SumOfGPWCancelCount  as [Cancel Count]
,GPWContractDataSummary.SumOfGPWActiveReserve  as [Active Rx]
,GPWContractDataSummary.SumOfGPWCancelReserve  as [Cancel Rx]
,0  as [MM Earned]
,GPWClaimsDataSummary.SumOfGPWActiveClaimCount  as [Active Claim Count]
,GPWClaimsDataSummary.SumOfGPWCancelClaimCount  as [Cancel Claim Count]
,GPWClaimsDataSummary.SumOfGPWClaimCount  as [Claim Count]
,GPWClaimsDataSummary.SumOfGPWActiveClaims  as [Active Claims]
,GPWClaimsDataSummary.SumOfGPWCancelClaims  as [Cancel Claims]
,GPWClaimsDataSummary.SumOfGPWClaims  as Claims
,GPWClaimsDataSummary.SumOfGPWClaims1  as ClaimsQtr1
,GPWClaimsDataSummary.SumOfGPWClaims2  as ClaimsQtr2
,GPWClaimsDataSummary.SumOfGPWClaims3  as ClaimsQtr3
,GPWClaimsDataSummary.SumOfGPWClaims4  as ClaimsQtr4
,GPWClaimsDataSummary.SumOfGPWClaims5  as ClaimsQtr5
,GPWClaimsDataSummary.SumOfGPWClaims6  as ClaimsQtr6
,GPWClaimsDataSummary.SumOfGPWClaims7  as ClaimsQtr7
,GPWClaimsDataSummary.SumOfGPWClaims8  as ClaimsQtr8
,GPWClaimsDataSummary.SumOfGPWClaims9  as ClaimsQtr9
,GPWClaimsDataSummary.SumOfGPWClaims10  as ClaimsQtr10
,GPWClaimsDataSummary.SumOfGPWClaims11  as ClaimsQtr11
,GPWClaimsDataSummary.SumOfGPWClaims12  as ClaimsQtr12
,GPWClaimsDataSummary.SumOfGPWClaims13  as ClaimsQtr13
,GPWClaimsDataSummary.SumOfGPWClaims14  as ClaimsQtr14
,GPWClaimsDataSummary.SumOfGPWClaims15  as ClaimsQtr15
,GPWClaimsDataSummary.SumOfGPWClaims16  as ClaimsQtr16
,GPWClaimsDataSummary.SumOfGPWClaims17  as ClaimsQtr17
,GPWClaimsDataSummary.SumOfGPWClaims18  as ClaimsQtr18
,GPWClaimsDataSummary.SumOfGPWClaims19  as ClaimsQtr19
,GPWClaimsDataSummary.SumOfGPWClaims20  as ClaimsQtr20
,GPWClaimsDataSummary.SumOfGPWClaims21  as ClaimsQtr21
,GPWClaimsDataSummary.SumOfGPWClaims22  as ClaimsQtr22
,GPWClaimsDataSummary.SumOfGPWClaims23  as ClaimsQtr23
,GPWClaimsDataSummary.SumOfGPWClaims24 as ClaimsQtr24
,GPWClaimsDataSummary.SumOfGPWClaims25  as ClaimsQtr25
,GPWClaimsDataSummary.SumOfGPWClaims26 as ClaimsQtr26
,GPWClaimsDataSummary.SumOfGPWClaims27  as ClaimsQtr27
,GPWClaimsDataSummary.SumOfGPWClaims28 as ClaimsQtr28
,GPWClaimsDataSummary.SumOfGPWClaims29  as ClaimsQtr29
,GPWClaimsDataSummary.SumOfGPWClaims30 as ClaimsQtr30
,GPWClaimsDataSummary.SumOfGPWClaims31  as ClaimsQtr31
,GPWClaimsDataSummary.SumOfGPWClaims32 as ClaimsQtr32
,GPWClaimsDataSummary.SumOfGPWClaims33  as ClaimsQtr33
,GPWClaimsDataSummary.SumOfGPWClaims34 as ClaimsQtr34
,GPWClaimsDataSummary.SumOfGPWClaims35  as ClaimsQtr35
,GPWClaimsDataSummary.SumOfGPWClaims36 as ClaimsQtr36
,GPWClaimsDataSummary.SumOfGPWClaims37  as ClaimsQtr37
,GPWClaimsDataSummary.SumOfGPWClaims38 as ClaimsQtr38
,GPWClaimsDataSummary.SumOfGPWClaims39  as ClaimsQtr39
,GPWClaimsDataSummary.SumOfGPWClaims40  as ClaimsQtr40
,GPWClaimsDataSummary.SumOfGPWClaimCount1  as ClaimCountQtr1
,GPWClaimsDataSummary.SumOfGPWClaimCount2  as ClaimCountQtr2
,GPWClaimsDataSummary.SumOfGPWClaimCount3  as ClaimCountQtr3
,GPWClaimsDataSummary.SumOfGPWClaimCount4  as ClaimCountQtr4
,GPWClaimsDataSummary.SumOfGPWClaimCount5  as ClaimCountQtr5
,GPWClaimsDataSummary.SumOfGPWClaimCount6  as ClaimCountQtr6
,GPWClaimsDataSummary.SumOfGPWClaimCount7  as ClaimCountQtr7
,GPWClaimsDataSummary.SumOfGPWClaimCount8  as ClaimCountQtr8
,GPWClaimsDataSummary.SumOfGPWClaimCount9  as ClaimCountQtr9
,GPWClaimsDataSummary.SumOfGPWClaimCount10  as ClaimCountQtr10
,GPWClaimsDataSummary.SumOfGPWClaimCount11  as ClaimCountQtr11
,GPWClaimsDataSummary.SumOfGPWClaimCount12  as ClaimCountQtr12
,GPWClaimsDataSummary.SumOfGPWClaimCount13  as ClaimCountQtr13
,GPWClaimsDataSummary.SumOfGPWClaimCount14  as ClaimCountQtr14
,GPWClaimsDataSummary.SumOfGPWClaimCount15  as ClaimCountQtr15
,GPWClaimsDataSummary.SumOfGPWClaimCount16  as ClaimCountQtr16
,GPWClaimsDataSummary.SumOfGPWClaimCount17  as ClaimCountQtr17
,GPWClaimsDataSummary.SumOfGPWClaimCount18  as ClaimCountQtr18
,GPWClaimsDataSummary.SumOfGPWClaimCount19  as ClaimCountQtr19
,GPWClaimsDataSummary.SumOfGPWClaimCount20  as ClaimCountQtr20
,GPWClaimsDataSummary.SumOfGPWClaimCount21  as ClaimCountQtr21
,GPWClaimsDataSummary.SumOfGPWClaimCount22  as ClaimCountQtr22
,GPWClaimsDataSummary.SumOfGPWClaimCount23  as ClaimCountQtr23
,GPWClaimsDataSummary.SumOfGPWClaimCount24  as ClaimCountQtr24
,GPWClaimsDataSummary.SumOfGPWClaimCount25  as ClaimCountQtr25
,GPWClaimsDataSummary.SumOfGPWClaimCount26  as ClaimCountQtr26
,GPWClaimsDataSummary.SumOfGPWClaimCount27  as ClaimCountQtr27
,GPWClaimsDataSummary.SumOfGPWClaimCount28  as ClaimCountQtr28
,GPWClaimsDataSummary.SumOfGPWClaimCount29  as ClaimCountQtr29
,GPWClaimsDataSummary.SumOfGPWClaimCount30  as ClaimCountQtr30
,GPWClaimsDataSummary.SumOfGPWClaimCount31  as ClaimCountQtr31
,GPWClaimsDataSummary.SumOfGPWClaimCount32  as ClaimCountQtr32
,GPWClaimsDataSummary.SumOfGPWClaimCount33  as ClaimCountQtr33
,GPWClaimsDataSummary.SumOfGPWClaimCount34  as ClaimCountQtr34
,GPWClaimsDataSummary.SumOfGPWClaimCount35  as ClaimCountQtr35
,GPWClaimsDataSummary.SumOfGPWClaimCount36  as ClaimCountQtr36
,GPWClaimsDataSummary.SumOfGPWClaimCount37  as ClaimCountQtr37
,GPWClaimsDataSummary.SumOfGPWClaimCount38  as ClaimCountQtr38
,GPWClaimsDataSummary.SumOfGPWClaimCount39  as ClaimCountQtr39
,GPWClaimsDataSummary.SumOfGPWClaimCount40  as ClaimCountQtr40
,GPWContractDataSummary.SumOfGPWCancelCount1  as CancelCountQtr1
,GPWContractDataSummary.SumOfGPWCancelCount2  as CancelCountQtr2
,GPWContractDataSummary.SumOfGPWCancelCount3  as CancelCountQtr3
,GPWContractDataSummary.SumOfGPWCancelCount4  as CancelCountQtr4
,GPWContractDataSummary.SumOfGPWCancelCount5  as CancelCountQtr5
,GPWContractDataSummary.SumOfGPWCancelCount6  as CancelCountQtr6
,GPWContractDataSummary.SumOfGPWCancelCount7  as CancelCountQtr7
,GPWContractDataSummary.SumOfGPWCancelCount8  as CancelCountQtr8
,GPWContractDataSummary.SumOfGPWCancelCount9  as CancelCountQtr9
,GPWContractDataSummary.SumOfGPWCancelCount10  as CancelCountQtr10
,GPWContractDataSummary.SumOfGPWCancelCount11  as CancelCountQtr11
,GPWContractDataSummary.SumOfGPWCancelCount12  as CancelCountQtr12
,GPWContractDataSummary.SumOfGPWCancelCount13  as CancelCountQtr13
,GPWContractDataSummary.SumOfGPWCancelCount14  as CancelCountQtr14
,GPWContractDataSummary.SumOfGPWCancelCount15  as CancelCountQtr15
,GPWContractDataSummary.SumOfGPWCancelCount16  as CancelCountQtr16
,GPWContractDataSummary.SumOfGPWCancelCount17  as CancelCountQtr17
,GPWContractDataSummary.SumOfGPWCancelCount18  as CancelCountQtr18
,GPWContractDataSummary.SumOfGPWCancelCount19  as CancelCountQtr19
,GPWContractDataSummary.SumOfGPWCancelCount20  as CancelCountQtr20
,GPWContractDataSummary.SumOfGPWCancelCount21  as CancelCountQtr21
,GPWContractDataSummary.SumOfGPWCancelCount22  as CancelCountQtr22
,GPWContractDataSummary.SumOfGPWCancelCount23  as CancelCountQtr23
,GPWContractDataSummary.SumOfGPWCancelCount24  as CancelCountQtr24
,GPWContractDataSummary.SumOfGPWCancelCount25  as CancelCountQtr25
,GPWContractDataSummary.SumOfGPWCancelCount26  as CancelCountQtr26
,GPWContractDataSummary.SumOfGPWCancelCount27  as CancelCountQtr27
,GPWContractDataSummary.SumOfGPWCancelCount28  as CancelCountQtr28
,GPWContractDataSummary.SumOfGPWCancelCount29  as CancelCountQtr29
,GPWContractDataSummary.SumOfGPWCancelCount30  as CancelCountQtr30
,GPWContractDataSummary.SumOfGPWCancelCount31  as CancelCountQtr31
,GPWContractDataSummary.SumOfGPWCancelCount32  as CancelCountQtr32
,GPWContractDataSummary.SumOfGPWCancelCount33  as CancelCountQtr33
,GPWContractDataSummary.SumOfGPWCancelCount34  as CancelCountQtr34
,GPWContractDataSummary.SumOfGPWCancelCount35  as CancelCountQtr35
,GPWContractDataSummary.SumOfGPWCancelCount36  as CancelCountQtr36
,GPWContractDataSummary.SumOfGPWCancelCount37  as CancelCountQtr37
,GPWContractDataSummary.SumOfGPWCancelCount38  as CancelCountQtr38
,GPWContractDataSummary.SumOfGPWCancelCount39  as CancelCountQtr39
,GPWContractDataSummary.SumOfGPWCancelCount40 as CancelCountQtr40
,0 as [MM Earned Qtr End]
,GPWContractDataSummary.SumOfGPWCancelRx1  as CancelRxQtr1
,GPWContractDataSummary.SumOfGPWCancelRx2  as CancelRxQtr2
,GPWContractDataSummary.SumOfGPWCancelRx3  as CancelRxQtr3
,GPWContractDataSummary.SumOfGPWCancelRx4  as CancelRxQtr4
,GPWContractDataSummary.SumOfGPWCancelRx5  as CancelRxQtr5
,GPWContractDataSummary.SumOfGPWCancelRx6  as CancelRxQtr6
,GPWContractDataSummary.SumOfGPWCancelRx7  as CancelRxQtr7
,GPWContractDataSummary.SumOfGPWCancelRx8  as CancelRxQtr8
,GPWContractDataSummary.SumOfGPWCancelRx9  as CancelRxQtr9
,GPWContractDataSummary.SumOfGPWCancelRx10  as CancelRxQtr10
,GPWContractDataSummary.SumOfGPWCancelRx11  as CancelRxQtr11
,GPWContractDataSummary.SumOfGPWCancelRx12  as CancelRxQtr12
,GPWContractDataSummary.SumOfGPWCancelRx13  as CancelRxQtr13
,GPWContractDataSummary.SumOfGPWCancelRx14  as CancelRxQtr14
,GPWContractDataSummary.SumOfGPWCancelRx15  as CancelRxQtr15
,GPWContractDataSummary.SumOfGPWCancelRx16  as CancelRxQtr16
,GPWContractDataSummary.SumOfGPWCancelRx17  as CancelRxQtr17
,GPWContractDataSummary.SumOfGPWCancelRx18  as CancelRxQtr18
,GPWContractDataSummary.SumOfGPWCancelRx19  as CancelRxQtr19
,GPWContractDataSummary.SumOfGPWCancelRx20  as CancelRxQtr20
,GPWContractDataSummary.SumOfGPWCancelRx21  as CancelRxQtr21
,GPWContractDataSummary.SumOfGPWCancelRx22  as CancelRxQtr22
,GPWContractDataSummary.SumOfGPWCancelRx23  as CancelRxQtr23
,GPWContractDataSummary.SumOfGPWCancelRx24  as CancelRxQtr24
,GPWContractDataSummary.SumOfGPWCancelRx25  as CancelRxQtr25
,GPWContractDataSummary.SumOfGPWCancelRx26  as CancelRxQtr26
,GPWContractDataSummary.SumOfGPWCancelRx27  as CancelRxQtr27
,GPWContractDataSummary.SumOfGPWCancelRx28  as CancelRxQtr28
,GPWContractDataSummary.SumOfGPWCancelRx29  as CancelRxQtr29
,GPWContractDataSummary.SumOfGPWCancelRx30  as CancelRxQtr30
,GPWContractDataSummary.SumOfGPWCancelRx31  as CancelRxQtr31
,GPWContractDataSummary.SumOfGPWCancelRx32  as CancelRxQtr32
,GPWContractDataSummary.SumOfGPWCancelRx33  as CancelRxQtr33
,GPWContractDataSummary.SumOfGPWCancelRx34  as CancelRxQtr34
,GPWContractDataSummary.SumOfGPWCancelRx35  as CancelRxQtr35
,GPWContractDataSummary.SumOfGPWCancelRx36  as CancelRxQtr36
,GPWContractDataSummary.SumOfGPWCancelRx37  as CancelRxQtr37
,GPWContractDataSummary.SumOfGPWCancelRx38  as CancelRxQtr38
,GPWContractDataSummary.SumOfGPWCancelRx39  as CancelRxQtr39
,GPWContractDataSummary.SumOfGPWCancelRx40  as CancelRxQtr40
INTO GPWDataSummaryQtrTest

FROM GPWContractDataSummary LEFT JOIN GPWClaimsDataSummary 

ON GPWContractDataSummary.GPWEffectiveQuarter = GPWClaimsDataSummary.GPWEffectiveQuarter
AND GPWContractDataSummary.GPWTermMonths = GPWClaimsDataSummary.GPWTermMonths
AND GPWContractDataSummary.[GPW N/U/P] = GPWClaimsDataSummary.[GPW N/U/P]
and GPWContractDataSummary.[GPW Channel] = GPWClaimsDataSummary.[GPW Channel]
and GPWContractDataSummary.[GPW Plan] = GPWClaimsDataSummary.[GPW Plan]

GO
