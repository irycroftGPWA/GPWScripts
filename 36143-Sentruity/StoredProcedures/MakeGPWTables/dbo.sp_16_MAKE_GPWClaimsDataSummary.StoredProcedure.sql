USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_16_MAKE_GPWClaimsDataSummary]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_16_MAKE_GPWClaimsDataSummary] AS

DECLARE @BegDate AS DATE
SET @BegDate = (SELECT BegDate FROM TBL_DBVALUES)
DECLARE @ValDate AS DATE
SET @ValDate = (SELECT ValDate FROM TBL_DBVALUES)


IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GPWClaimsDataSummary')
	DROP TABLE GPWClaimsDataSummary

;with HurricaneGapClaims as (
select GPWClaimsData.Contract_Id, GPWClaimsData.Claim_Number
from GPWClaimsData
LEFT OUTER JOIN dbo.[GAP_Claim_Descriptions_Summed_12_2022] ON 
                  dbo.GPWClaimsData.Claim_Number = dbo.[GAP_Claim_Descriptions_Summed_12_2022].[Claim No] AND 
                  dbo.GPWClaimsData.Contract_Id = dbo.[GAP_Claim_Descriptions_Summed_12_2022].[Contract ID]
Where ((dbo.GPWClaimsData.[GPWClaimDate] > CONVERT(DATETIME, '2017-08-24 00:00:00', 102) AND dbo.GPWClaimsData.[GPWClaimDate] < CONVERT(DATETIME, '2017-09-05 00:00:00', 102)) AND 
                  (dbo.[GAP_Claim_Descriptions_Summed_12_2022].[Loss Cause Desc] = N'GAP Buyout - Flood'))
)

SELECT
GPWCoverage as sqlcat1,
GPWSentruityInsured as sqlcat2,
GPWReinsurer as sqlcat3,
GPWClaimsData.GPWCoverage, 
GPWClaimsData.[GPW N/U/P], 
GPWClaimsData.GPWTermMonths, 
GPWClaimsData.GPWEffectiveQuarter,
GPWAgg_CCC,
GPWAgg_GAP,
GPWAgg_LTW,
GPWAgg_MTNG,
GPWAgg_SDC,
GPWAgg_SNV,
GPWAgg_TEC,
GPWAgg_VSC_MBI, 
GPWAgg_ANCL, 
Sum(GPWClaimsData.GPWActiveClaimCount) AS SumOfGPWActiveClaimCount, 
Sum(GPWClaimsData.GPWCancelClaimCount) AS SumOfGPWCancelClaimCount, 
Sum(GPWClaimsData.GPWClaimCount) AS SumOfGPWClaimCount, 
Sum(GPWClaimsData.GPWActiveClaims) AS SumOfGPWActiveClaims, 
Sum(GPWClaimsData.GPWCancelClaims) AS SumOfGPWCancelClaims, 
Sum(GPWClaimsData.GPWClaims) AS SumOfGPWClaims, 
Sum(GPWClaimsData.GPWClaims1) AS SumOfGPWClaims1, 
Sum(GPWClaimsData.GPWClaims2) AS SumOfGPWClaims2, 
Sum(GPWClaimsData.GPWClaims3) AS SumOfGPWClaims3, 
Sum(GPWClaimsData.GPWClaims4) AS SumOfGPWClaims4, 
Sum(GPWClaimsData.GPWClaims5) AS SumOfGPWClaims5, 
Sum(GPWClaimsData.GPWClaims6) AS SumOfGPWClaims6,
Sum(GPWClaimsData.GPWClaims7) AS SumOfGPWClaims7, 
Sum(GPWClaimsData.GPWClaims8) AS SumOfGPWClaims8, 
Sum(GPWClaimsData.GPWClaims9) AS SumOfGPWClaims9, 
Sum(GPWClaimsData.GPWClaims10) AS SumOfGPWClaims10, 
Sum(GPWClaimsData.GPWClaims11) AS SumOfGPWClaims11, 
Sum(GPWClaimsData.GPWClaims12) AS SumOfGPWClaims12, 
Sum(GPWClaimsData.GPWClaims13) AS SumOfGPWClaims13, 
Sum(GPWClaimsData.GPWClaims14) AS SumOfGPWClaims14, 
Sum(GPWClaimsData.GPWClaims15) AS SumOfGPWClaims15, 
Sum(GPWClaimsData.GPWClaims16) AS SumOfGPWClaims16, 
Sum(GPWClaimsData.GPWClaims17) AS SumOfGPWClaims17, 
Sum(GPWClaimsData.GPWClaims18) AS SumOfGPWClaims18, 
Sum(GPWClaimsData.GPWClaims19) AS SumOfGPWClaims19, 
Sum(GPWClaimsData.GPWClaims20) AS SumOfGPWClaims20, 
Sum(GPWClaimsData.GPWClaims21) AS SumOfGPWClaims21, 
Sum(GPWClaimsData.GPWClaims22) AS SumOfGPWClaims22, 
Sum(GPWClaimsData.GPWClaims23) AS SumOfGPWClaims23, 
Sum(GPWClaimsData.GPWClaims24) AS SumOfGPWClaims24, 
Sum(GPWClaimsData.GPWClaims25) AS SumOfGPWClaims25, 
Sum(GPWClaimsData.GPWClaims26) AS SumOfGPWClaims26, 
Sum(GPWClaimsData.GPWClaims27) AS SumOfGPWClaims27, 
Sum(GPWClaimsData.GPWClaims28) AS SumOfGPWClaims28, 
Sum(GPWClaimsData.GPWClaims29) AS SumOfGPWClaims29, 
Sum(GPWClaimsData.GPWClaims30) AS SumOfGPWClaims30, 
Sum(GPWClaimsData.GPWClaims31) AS SumOfGPWClaims31, 
Sum(GPWClaimsData.GPWClaims32) AS SumOfGPWClaims32, 
Sum(GPWClaimsData.GPWClaims33) AS SumOfGPWClaims33, 
Sum(GPWClaimsData.GPWClaims34) AS SumOfGPWClaims34, 
Sum(GPWClaimsData.GPWClaims35) AS SumOfGPWClaims35, 
Sum(GPWClaimsData.GPWClaims36) AS SumOfGPWClaims36, 
Sum(GPWClaimsData.GPWClaims37) AS SumOfGPWClaims37, 
Sum(GPWClaimsData.GPWClaims38) AS SumOfGPWClaims38, 
Sum(GPWClaimsData.GPWClaims39) AS SumOfGPWClaims39, 
Sum(GPWClaimsData.GPWClaims40) AS SumOfGPWClaims40, 
Sum(GPWClaimsData.GPWClaimCount1) AS SumOfGPWClaimCount1, 
Sum(GPWClaimsData.GPWClaimCount2) AS SumOfGPWClaimCount2, 
Sum(GPWClaimsData.GPWClaimCount3) AS SumOfGPWClaimCount3, 
Sum(GPWClaimsData.GPWClaimCount4) AS SumOfGPWClaimCount4, 
Sum(GPWClaimsData.GPWClaimCount5) AS SumOfGPWClaimCount5, 
Sum(GPWClaimsData.GPWClaimCount6) AS SumOfGPWClaimCount6, 
Sum(GPWClaimsData.GPWClaimCount7) AS SumOfGPWClaimCount7, 
Sum(GPWClaimsData.GPWClaimCount8) AS SumOfGPWClaimCount8, 
Sum(GPWClaimsData.GPWClaimCount9) AS SumOfGPWClaimCount9,
Sum(GPWClaimsData.GPWClaimCount10) AS SumOfGPWClaimCount10, 
Sum(GPWClaimsData.GPWClaimCount11) AS SumOfGPWClaimCount11, 
Sum(GPWClaimsData.GPWClaimCount12) AS SumOfGPWClaimCount12, 
Sum(GPWClaimsData.GPWClaimCount13) AS SumOfGPWClaimCount13, 
Sum(GPWClaimsData.GPWClaimCount14) AS SumOfGPWClaimCount14, 
Sum(GPWClaimsData.GPWClaimCount15) AS SumOfGPWClaimCount15, 
Sum(GPWClaimsData.GPWClaimCount16) AS SumOfGPWClaimCount16, 
Sum(GPWClaimsData.GPWClaimCount17) AS SumOfGPWClaimCount17, 
Sum(GPWClaimsData.GPWClaimCount18) AS SumOfGPWClaimCount18, 
Sum(GPWClaimsData.GPWClaimCount19) AS SumOfGPWClaimCount19, 
Sum(GPWClaimsData.GPWClaimCount20) AS SumOfGPWClaimCount20, 
Sum(GPWClaimsData.GPWClaimCount21) AS SumOfGPWClaimCount21, 
Sum(GPWClaimsData.GPWClaimCount22) AS SumOfGPWClaimCount22, 
Sum(GPWClaimsData.GPWClaimCount23) AS SumOfGPWClaimCount23, 
Sum(GPWClaimsData.GPWClaimCount24) AS SumOfGPWClaimCount24, 
Sum(GPWClaimsData.GPWClaimCount25) AS SumOfGPWClaimCount25, 
Sum(GPWClaimsData.GPWClaimCount26) AS SumOfGPWClaimCount26, 
Sum(GPWClaimsData.GPWClaimCount27) AS SumOfGPWClaimCount27, 
Sum(GPWClaimsData.GPWClaimCount28) AS SumOfGPWClaimCount28, 
Sum(GPWClaimsData.GPWClaimCount29) AS SumOfGPWClaimCount29, 
Sum(GPWClaimsData.GPWClaimCount30) AS SumOfGPWClaimCount30, 
Sum(GPWClaimsData.GPWClaimCount31) AS SumOfGPWClaimCount31, 
Sum(GPWClaimsData.GPWClaimCount32) AS SumOfGPWClaimCount32, 
Sum(GPWClaimsData.GPWClaimCount33) AS SumOfGPWClaimCount33, 
Sum(GPWClaimsData.GPWClaimCount34) AS SumOfGPWClaimCount34, 
Sum(GPWClaimsData.GPWClaimCount35) AS SumOfGPWClaimCount35, 
Sum(GPWClaimsData.GPWClaimCount36) AS SumOfGPWClaimCount36, 
Sum(GPWClaimsData.GPWClaimCount37) AS SumOfGPWClaimCount37, 
Sum(GPWClaimsData.GPWClaimCount38) AS SumOfGPWClaimCount38, 
Sum(GPWClaimsData.GPWClaimCount39) AS SumOfGPWClaimCount39, 
Sum(GPWClaimsData.GPWClaimCount40) AS SumOfGPWClaimCount40 
INTO GPWClaimsDataSummary
FROM GPWClaimsData
left join HurricaneGapClaims on HurricaneGapClaims.Claim_Number = GPWClaimsData.Claim_Number and HurricaneGapClaims.Contract_Id = GPWClaimsData.Contract_Id
WHERE 
(
(((GPWClaimsData.GPWClaimDate<=@ValDate) 
AND (GPWClaimsData.GPWRelativeClaimQtr)>0) 
AND (GPWClaimsData.GPWClaimCount > 0) 
AND ((GPWClaimsData.GPWEffectiveDate)<=@ValDate) 
AND ((GPWClaimsData.GPWTermMonths)>0 
And (GPWClaimsData.GPWTermMonths)<121) 
AND ((GPWClaimsData.GPWContractCount)> 0)
and ((GPWClaimsData.GPWActiveReserve)>0)) 
OR (((GPWClaimsData.GPWClaimDate)<=@ValDate) 
AND ((GPWClaimsData.GPWRelativeClaimQtr)>0) 
AND ((GPWClaimsData.GPWClaimCount) > 0) 
AND ((GPWClaimsData.GPWEffectiveDate)<=@ValDate) 
AND ((GPWClaimsData.GPWTermMonths)>0 
And (GPWClaimsData.GPWTermMonths)<121) 
AND ((GPWClaimsData.GPWContractCount)> 0)
and ((GPWClaimsData.GPWCancelReserve)>0))
)
and HurricaneGapClaims.Contract_Id is null
-- Three coverages excluded since we need to specify GPWReinsurer field. All Excess coverages are exclusive of GPWReinsurer and so are included
-- in this general GPWClaimsDataSummary

GROUP BY GPWClaimsData.GPWCoverage, GPWClaimsData.[GPW N/U/P], 
GPWClaimsData.GPWTermMonths, GPWClaimsData.GPWEffectiveQuarter,
GPWReinsurer,
GPWSentruityInsured,
GPWAgg_CCC,
GPWAgg_GAP,
GPWAgg_LTW,
GPWAgg_MTNG,
GPWAgg_SDC,
GPWAgg_SNV,
GPWAgg_TEC,
GPWAgg_VSC_MBI,
GPWAgg_ANCL
GO
