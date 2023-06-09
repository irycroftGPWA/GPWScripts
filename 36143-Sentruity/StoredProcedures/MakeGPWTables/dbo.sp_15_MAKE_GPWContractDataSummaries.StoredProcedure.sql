USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_15_MAKE_GPWContractDataSummaries]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_15_MAKE_GPWContractDataSummaries] AS

DECLARE @BegDate AS DATE
SET @BegDate = (SELECT BegDate FROM TBL_DBVALUES)
DECLARE @ValDate AS DATE
SET @ValDate = (SELECT ValDate FROM TBL_DBVALUES)

---------------------------------------- RRG - First Dollar RETAINED

IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GPWContractDataSummary')
	DROP TABLE GPWContractDataSummary
SELECT
GPWCoverage AS SQLCat1,
GPWSentruityInsured AS SQLCat2,
GPWReinsurer AS SQLCat3,
GPWContractData.GPWCoverage, 
GPWContractData.[GPW N/U/P], 
GPWContractData.GPWTermMonths, 
GPWContractData.GPWEffectiveQuarter,
GPWAgg_CCC,
GPWAgg_GAP,
GPWAgg_LTW,
GPWAgg_MTNG,
GPWAgg_SDC,
GPWAgg_SNV,
GPWAgg_TEC,
GPWAgg_VSC_MBI, 
GPWAgg_ANCL, 
Sum(GPWContractData.GPWContractCount) AS SumOfGPWContractCount, 
Sum(GPWContractData.GPWCancelCount) AS SumOfGPWCancelCount, 
Sum(GPWContractData.GPWActiveReserve) AS SumOfGPWActiveReserve, 
Sum(GPWContractData.GPWCancelReserve) AS SumOfGPWCancelReserve, 
Sum(GPWContractData.GPWMMEarned) AS SumOfGPWMMEarned, 
Sum(GPWContractData.GPWCancelCount1) AS SumOfGPWCancelCount1, 
Sum(GPWContractData.GPWCancelCount2) AS SumOfGPWCancelCount2, 
Sum(GPWContractData.GPWCancelCount3) AS SumOfGPWCancelCount3, 
Sum(GPWContractData.GPWCancelCount4) AS SumOfGPWCancelCount4, 
Sum(GPWContractData.GPWCancelCount5) AS SumOfGPWCancelCount5, 
Sum(GPWContractData.GPWCancelCount6) AS SumOfGPWCancelCount6, 
Sum(GPWContractData.GPWCancelCount7) AS SumOfGPWCancelCount7, 
Sum(GPWContractData.GPWCancelCount8) AS SumOfGPWCancelCount8, 
Sum(GPWContractData.GPWCancelCount9) AS SumOfGPWCancelCount9, 
Sum(GPWContractData.GPWCancelCount10) AS SumOfGPWCancelCount10, 
Sum(GPWContractData.GPWCancelCount11) AS SumOfGPWCancelCount11, 
Sum(GPWContractData.GPWCancelCount12) AS SumOfGPWCancelCount12, 
Sum(GPWContractData.GPWCancelCount13) AS SumOfGPWCancelCount13, 
Sum(GPWContractData.GPWCancelCount14) AS SumOfGPWCancelCount14, 
Sum(GPWContractData.GPWCancelCount15) AS SumOfGPWCancelCount15, 
Sum(GPWContractData.GPWCancelCount16) AS SumOfGPWCancelCount16, 
Sum(GPWContractData.GPWCancelCount17) AS SumOfGPWCancelCount17, 
Sum(GPWContractData.GPWCancelCount18) AS SumOfGPWCancelCount18, 
Sum(GPWContractData.GPWCancelCount19) AS SumOfGPWCancelCount19, 
Sum(GPWContractData.GPWCancelCount20) AS SumOfGPWCancelCount20, 
Sum(GPWContractData.GPWCancelCount21) AS SumOfGPWCancelCount21, 
Sum(GPWContractData.GPWCancelCount22) AS SumOfGPWCancelCount22, 
Sum(GPWContractData.GPWCancelCount23) AS SumOfGPWCancelCount23, 
Sum(GPWContractData.GPWCancelCount24) AS SumOfGPWCancelCount24, 
Sum(GPWContractData.GPWCancelCount25) AS SumOfGPWCancelCount25, 
Sum(GPWContractData.GPWCancelCount26) AS SumOfGPWCancelCount26, 
Sum(GPWContractData.GPWCancelCount27) AS SumOfGPWCancelCount27, 
Sum(GPWContractData.GPWCancelCount28) AS SumOfGPWCancelCount28, 
Sum(GPWContractData.GPWCancelCount29) AS SumOfGPWCancelCount29, 
Sum(GPWContractData.GPWCancelCount30) AS SumOfGPWCancelCount30, 
Sum(GPWContractData.GPWCancelCount31) AS SumOfGPWCancelCount31, 
Sum(GPWContractData.GPWCancelCount32) AS SumOfGPWCancelCount32, 
Sum(GPWContractData.GPWCancelCount33) AS SumOfGPWCancelCount33, 
Sum(GPWContractData.GPWCancelCount34) AS SumOfGPWCancelCount34, 
Sum(GPWContractData.GPWCancelCount35) AS SumOfGPWCancelCount35, 
Sum(GPWContractData.GPWCancelCount36) AS SumOfGPWCancelCount36, 
Sum(GPWContractData.GPWCancelCount37) AS SumOfGPWCancelCount37, 
Sum(GPWContractData.GPWCancelCount38) AS SumOfGPWCancelCount38, 
Sum(GPWContractData.GPWCancelCount39) AS SumOfGPWCancelCount39, 
Sum(GPWContractData.GPWCancelCount40) AS SumOfGPWCancelCount40,
Sum(GPWContractData.GPWCancelRx1) AS SumOfGPWCancelRx1, 
Sum(GPWContractData.GPWCancelRx2) AS SumOfGPWCancelRx2, 
Sum(GPWContractData.GPWCancelRx3) AS SumOfGPWCancelRx3, 
Sum(GPWContractData.GPWCancelRx4) AS SumOfGPWCancelRx4, 
Sum(GPWContractData.GPWCancelRx5) AS SumOfGPWCancelRx5, 
Sum(GPWContractData.GPWCancelRx6) AS SumOfGPWCancelRx6, 
Sum(GPWContractData.GPWCancelRx7) AS SumOfGPWCancelRx7, 
Sum(GPWContractData.GPWCancelRx8) AS SumOfGPWCancelRx8, 
Sum(GPWContractData.GPWCancelRx9) AS SumOfGPWCancelRx9, 
Sum(GPWContractData.GPWCancelRx10) AS SumOfGPWCancelRx10, 
Sum(GPWContractData.GPWCancelRx11) AS SumOfGPWCancelRx11, 
Sum(GPWContractData.GPWCancelRx12) AS SumOfGPWCancelRx12, 
Sum(GPWContractData.GPWCancelRx13) AS SumOfGPWCancelRx13, 
Sum(GPWContractData.GPWCancelRx14) AS SumOfGPWCancelRx14, 
Sum(GPWContractData.GPWCancelRx15) AS SumOfGPWCancelRx15, 
Sum(GPWContractData.GPWCancelRx16) AS SumOfGPWCancelRx16, 
Sum(GPWContractData.GPWCancelRx17) AS SumOfGPWCancelRx17, 
Sum(GPWContractData.GPWCancelRx18) AS SumOfGPWCancelRx18, 
Sum(GPWContractData.GPWCancelRx19) AS SumOfGPWCancelRx19, 
Sum(GPWContractData.GPWCancelRx20) AS SumOfGPWCancelRx20, 
Sum(GPWContractData.GPWCancelRx21) AS SumOfGPWCancelRx21, 
Sum(GPWContractData.GPWCancelRx22) AS SumOfGPWCancelRx22, 
Sum(GPWContractData.GPWCancelRx23) AS SumOfGPWCancelRx23, 
Sum(GPWContractData.GPWCancelRx24) AS SumOfGPWCancelRx24, 
Sum(GPWContractData.GPWCancelRx25) AS SumOfGPWCancelRx25, 
Sum(GPWContractData.GPWCancelRx26) AS SumOfGPWCancelRx26, 
Sum(GPWContractData.GPWCancelRx27) AS SumOfGPWCancelRx27, 
Sum(GPWContractData.GPWCancelRx28) AS SumOfGPWCancelRx28, 
Sum(GPWContractData.GPWCancelRx29) AS SumOfGPWCancelRx29, 
Sum(GPWContractData.GPWCancelRx30) AS SumOfGPWCancelRx30, 
Sum(GPWContractData.GPWCancelRx31) AS SumOfGPWCancelRx31, 
Sum(GPWContractData.GPWCancelRx32) AS SumOfGPWCancelRx32, 
Sum(GPWContractData.GPWCancelRx33) AS SumOfGPWCancelRx33, 
Sum(GPWContractData.GPWCancelRx34) AS SumOfGPWCancelRx34, 
Sum(GPWContractData.GPWCancelRx35) AS SumOfGPWCancelRx35, 
Sum(GPWContractData.GPWCancelRx36) AS SumOfGPWCancelRx36, 
Sum(GPWContractData.GPWCancelRx37) AS SumOfGPWCancelRx37, 
Sum(GPWContractData.GPWCancelRx38) AS SumOfGPWCancelRx38, 
Sum(GPWContractData.GPWCancelRx39) AS SumOfGPWCancelRx39, 
Sum(GPWContractData.GPWCancelRx40) AS SumOfGPWCancelRx40  
 
INTO GPWContractDataSummary
FROM GPWContractData
WHERE (((GPWContractData.GPWEffectiveDate) between @begDate and @valdate) 
AND ((GPWContractData.GPWTermMonths)>0 
And (GPWContractData.GPWTermMonths)<121) 
AND ((GPWContractData.GPWRelativeCancelQtr)>=0) 
AND ((GPWContractData.GPWContractCount) > 0) 
AND ((GPWContractData.GPWActiveReserve)>0)) 
OR (((GPWContractData.GPWEffectiveDate) between @begDate and @valdate) 
AND ((GPWContractData.GPWTermMonths)>0 
And (GPWContractData.GPWTermMonths)<121) 
AND ((GPWContractData.GPWRelativeCancelQtr)>=0) 
AND ((GPWContractData.GPWContractCount) > 0) 
AND ((GPWContractData.GPWCancelReserve)>0))
GROUP BY GPWContractData.GPWCoverage, 
GPWContractData.[GPW N/U/P], 
GPWContractData.GPWTermMonths, 
GPWContractData.GPWEffectiveQuarter,
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
