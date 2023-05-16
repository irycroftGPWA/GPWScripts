USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_12_MAKE_GPWClaimsData]    Script Date: 5/16/2023 9:50:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_12_MAKE_GPWClaimsData] AS

DECLARE @BegDate AS DATE
SET @BegDate = (SELECT BegDate FROM TBL_DBVALUES)
DECLARE @ValDate AS DATE
SET @ValDate = (SELECT ValDate FROM TBL_DBVALUES)


IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GPWClaimsData')
	DROP TABLE GPWClaimsData
/*MAKE SURE GPW MILES COLUMNS ARE FLOATS*/
CREATE TABLE [GPWClaimsData] (
[Contract_Id] varchar(255) NULL, 
[Claim_Number] varchar (50) NULL,
[GPWClaimDate] datetime NULL, 
[GPWClaimQuarter] varchar (50) NULL, 
[GPWClaimQtr#] int NULL, 
[GPWRelativeClaimQtr] int NULL, 
[GPWClaimMiles] float NULL, 
[GPWActiveReserve] float NULL,
[GPWCancelReserve] float NULL,
[RecordCount] float NULL,
[GPWActiveClaimCount] FLOAT NULL, 
[GPWCancelClaimCount] float NULL, 
[GPWClaimCount] float NULL, 
[GPWActiveClaims] float NULL, 
[GPWCancelClaims] float NULL, 
[GPWClaims] float NULL, 
[Amount_Paid] float NULL,
[GPWObligor] varchar (50) NULL, 
[GPWCoverage] varchar (50) NULL, 
[GPW N/U/P] varchar (50) NULL, 
[GPWEffectiveDate] datetime NULL, 
[GPWEffectiveMiles] float NULL, 
[GPWTermMonths] float NULL, 
[GPWTermMiles] float NULL, 
[GPWCancelDate] datetime NULL, 
[GPWCancelMiles] float NULL, 
[GPWEffectiveQuarter] varchar (50) NULL, 
[GPWEffectiveQtr#] int NULL, 
[GPWEffectiveYear] int NULL, 
[GPWExpireDate] datetime NULL, 
[GPWExpireMiles] float NULL, 
[GPWAgg_VSC_MBI] varchar (50) NULL,
[GPWAgg_GAP] varchar (50) NULL,
[GPWAgg_SNV] varchar (50) NULL,
[GPWAgg_CCC] varchar (50) NULL,
[GPWAgg_TEC] varchar (50) NULL,
[GPWAgg_MTNG] varchar (50) NULL,
[GPWAgg_LTW] varchar (50) NULL,
[GPWAgg_SDC] varchar (50) NULL,
[GPWAgg_ANCL] varchar (50) NULL,
[GPWSentruityInsured] int NULL,
[GPWReinsurer] nvarchar (255) NULL,
[GPWCancelQuarter] varchar (50) NULL, 
[GPWCancelQtr#] int NULL, 
[GPWRelativeCancelQtr] int NULL, 
[GPWFlatCancel] varchar (50) NULL, 
[GPWContractCount] float NULL, 
[GPWCancelCount] float NULL, 
[GPWClaims1] float NULL, 
[GPWClaims2] float NULL, 
[GPWClaims3] float NULL, 
[GPWClaims4] float NULL, 
[GPWClaims5] float NULL, 
[GPWClaims6] float NULL, 
[GPWClaims7] float NULL, 
[GPWClaims8] float NULL, 
[GPWClaims9] float NULL, 
[GPWClaims10] float NULL, 
[GPWClaims11] float NULL, 
[GPWClaims12] float NULL, 
[GPWClaims13] float NULL, 
[GPWClaims14] float NULL, 
[GPWClaims15] float NULL, 
[GPWClaims16] float NULL, 
[GPWClaims17] float NULL, 
[GPWClaims18] float NULL, 
[GPWClaims19] float NULL, 
[GPWClaims20] float NULL, 
[GPWClaims21] float NULL, 
[GPWClaims22] float NULL, 
[GPWClaims23] float NULL, 
[GPWClaims24] float NULL, 
[GPWClaims25] float NULL, 
[GPWClaims26] float NULL, 
[GPWClaims27] float NULL, 
[GPWClaims28] float NULL, 
[GPWClaims29] float NULL, 
[GPWClaims30] float NULL, 
[GPWClaims31] float NULL, 
[GPWClaims32] float NULL, 
[GPWClaims33] float NULL, 
[GPWClaims34] float NULL, 
[GPWClaims35] float NULL, 
[GPWClaims36] float NULL, 
[GPWClaims37] float NULL, 
[GPWClaims38] float NULL, 
[GPWClaims39] float NULL, 
[GPWClaims40] float NULL, 
[GPWClaimCount1] float NULL, 
[GPWClaimCount2] float NULL, 
[GPWClaimCount3] float NULL, 
[GPWClaimCount4] float NULL, 
[GPWClaimCount5] float NULL, 
[GPWClaimCount6] float NULL, 
[GPWClaimCount7] float NULL, 
[GPWClaimCount8] float NULL, 
[GPWClaimCount9] float NULL, 
[GPWClaimCount10] float NULL, 
[GPWClaimCount11] float NULL, 
[GPWClaimCount12] float NULL, 
[GPWClaimCount13] float NULL, 
[GPWClaimCount14] float NULL, 
[GPWClaimCount15] float NULL, 
[GPWClaimCount16] float NULL, 
[GPWClaimCount17] float NULL, 
[GPWClaimCount18] float NULL, 
[GPWClaimCount19] float NULL, 
[GPWClaimCount20] float NULL, 
[GPWClaimCount21] float NULL, 
[GPWClaimCount22] float NULL, 
[GPWClaimCount23] float NULL, 
[GPWClaimCount24] float NULL, 
[GPWClaimCount25] float NULL, 
[GPWClaimCount26] float NULL, 
[GPWClaimCount27] float NULL, 
[GPWClaimCount28] float NULL, 
[GPWClaimCount29] float NULL, 
[GPWClaimCount30] float NULL, 
[GPWClaimCount31] float NULL, 
[GPWClaimCount32] float NULL, 
[GPWClaimCount33] float NULL, 
[GPWClaimCount34] float NULL, 
[GPWClaimCount35] float NULL, 
[GPWClaimCount36] float NULL, 
[GPWClaimCount37] float NULL, 
[GPWClaimCount38] float NULL, 
[GPWClaimCount39] float NULL, 
[GPWClaimCount40] float NULL )
INSERT INTO GPWClaimsData(
	[Contract_Id], 
	[Claim_Number] ,
	[GPWClaimDate],
	[GPWClaimQuarter],
	[GPWClaimQtr#],
	[GPWRelativeClaimQtr],
	[GPWClaimMiles], 
	[GPWActiveReserve],
	[GPWCancelReserve],
	[RecordCount],
	[GPWActiveClaimCount],
	[GPWCancelClaimCount],
	[GPWClaimCount],
	[GPWActiveClaims],
	[GPWCancelClaims],
	[GPWClaims],
	[Amount_Paid],
	[GPWObligor],
	[GPWCoverage],
	[GPW N/U/P],
	[GPWEffectiveDate],
	[GPWEffectiveMiles],
	[GPWTermMonths],
	[GPWTermMiles],
	[GPWCancelDate],

	[GPWCancelMiles],
	[GPWEffectiveQuarter],
	[GPWEffectiveQtr#],
	[GPWEffectiveYear],
	[GPWExpireDate],
	[GPWExpireMiles],
	[GPWAgg_VSC_MBI],
	[GPWAgg_GAP],
	[GPWAgg_SNV],
	[GPWAgg_CCC],
	[GPWAgg_TEC],
	[GPWAgg_MTNG] ,
	[GPWAgg_LTW] ,
	[GPWAgg_SDC] ,
	[GPWAgg_ANCL] ,
	[GPWSentruityInsured],
	[GPWReinsurer],
	[GPWCancelQuarter],
	[GPWCancelQtr#],
	[GPWRelativeCancelQtr],
	[GPWFlatCancel],
	[GPWContractCount],
	[GPWCancelCount],
	[GPWClaims1],
	[GPWClaims2],
	[GPWClaims3],
	[GPWClaims4],
	[GPWClaims5],
	[GPWClaims6],
	[GPWClaims7],
	[GPWClaims8],
	[GPWClaims9],
	[GPWClaims10],
	[GPWClaims11],
	[GPWClaims12],
	[GPWClaims13],
	[GPWClaims14],
	[GPWClaims15],
	[GPWClaims16],
	[GPWClaims17],
	[GPWClaims18],
	[GPWClaims19],
	[GPWClaims20],
	[GPWClaims21],
	[GPWClaims22],
	[GPWClaims23],
	[GPWClaims24],
	[GPWClaims25],
	[GPWClaims26],
	[GPWClaims27],
	[GPWClaims28],
	[GPWClaims29],
	[GPWClaims30],
	[GPWClaims31],
	[GPWClaims32],
	[GPWClaims33],
	[GPWClaims34],
	[GPWClaims35],
	[GPWClaims36],
	[GPWClaims37],
	[GPWClaims38],
	[GPWClaims39],
	[GPWClaims40],
	[GPWClaimCount1],
	[GPWClaimCount2],
	[GPWClaimCount3],
	[GPWClaimCount4],
	[GPWClaimCount5],
	[GPWClaimCount6],
	[GPWClaimCount7],
	[GPWClaimCount8],
	[GPWClaimCount9],
	[GPWClaimCount10],
	[GPWClaimCount11],
	[GPWClaimCount12],
	[GPWClaimCount13],
	[GPWClaimCount14],
	[GPWClaimCount15],
	[GPWClaimCount16],
	[GPWClaimCount17],
	[GPWClaimCount18],
	[GPWClaimCount19],
	[GPWClaimCount20],
	[GPWClaimCount21],
	[GPWClaimCount22],
	[GPWClaimCount23],
	[GPWClaimCount24],
	[GPWClaimCount25],
	[GPWClaimCount26],
	[GPWClaimCount27],
	[GPWClaimCount28],
	[GPWClaimCount29],
	[GPWClaimCount30],
	[GPWClaimCount31],
	[GPWClaimCount32],
	[GPWClaimCount33],
	[GPWClaimCount34],
	[GPWClaimCount35],
	[GPWClaimCount36],
	[GPWClaimCount37],
	[GPWClaimCount38],
	[GPWClaimCount39],
	[GPWClaimCount40])
SELECT 
	[Contract_Id], 
	[Claim_Number] ,
	[GPWClaimDate],
	[GPWClaimQuarter],
	[GPWClaimQtr#],
	[GPWRelativeClaimQtr],
	[GPWClaimMiles],
	[GPWActiveReserve],
	[GPWCancelReserve],
	1 as [RecordCount],
	[GPWActiveClaimCount],
	[GPWCancelClaimCount],
	[GPWClaimCount],
	[GPWActiveClaims],
	[GPWCancelClaims],
	[GPWClaims],
	[Amount_Paid],
	[GPWObligor],
	[GPWCoverage],
	[GPW N/U/P],
	[GPWEffectiveDate],
	[GPWEffectiveMiles],
	[GPWTermMonths],
	[GPWTermMiles],
	[GPWCancelDate],
	[GPWCancelMiles],
	[GPWEffectiveQuarter],
	[GPWEffectiveQtr#],
	[GPWEffectiveYear],
	[GPWExpireDate],
	[GPWExpireMiles],
	[GPWAgg_VSC_MBI],
	[GPWAgg_GAP],
	[GPWAgg_SNV],
	[GPWAgg_CCC],
	[GPWAgg_TEC],
	[GPWAgg_MTNG] ,
	[GPWAgg_LTW] ,
	[GPWAgg_SDC] ,
	[GPWAgg_ANCL] ,
	[GPWSentruityInsured],
	[GPWReinsurer],
	[GPWCancelQuarter],
	[GPWCancelQtr#],
	[GPWRelativeCancelQtr],
	[GPWFlatCancel],
	[GPWContractCount],
	[GPWCancelCount],
0 AS GPWClaims1, 
0 AS GPWClaims2, 
0 AS GPWClaims3, 
0 AS GPWClaims4, 
0 AS GPWClaims5, 
0 AS GPWClaims6, 
0 AS GPWClaims7, 
0 AS GPWClaims8, 
0 AS GPWClaims9, 
0 AS GPWClaims10, 
0 AS GPWClaims11, 
0 AS GPWClaims12, 
0 AS GPWClaims13, 
0 AS GPWClaims14, 
0 AS GPWClaims15, 
0 AS GPWClaims16, 
0 AS GPWClaims17, 
0 AS GPWClaims18, 
0 AS GPWClaims19, 
0 AS GPWClaims20, 
0 AS GPWClaims21, 
0 AS GPWClaims22, 
0 AS GPWClaims23, 
0 AS GPWClaims24, 
0 AS GPWClaims25, 
0 AS GPWClaims26, 
0 AS GPWClaims27, 
0 AS GPWClaims28, 
0 AS GPWClaims29, 
0 AS GPWClaims30, 
0 AS GPWClaims31, 
0 AS GPWClaims32, 
0 AS GPWClaims33, 
0 AS GPWClaims34, 
0 AS GPWClaims35, 
0 AS GPWClaims36, 
0 AS GPWClaims37, 
0 AS GPWClaims38, 
0 AS GPWClaims39, 
0 AS GPWClaims40, 
0 AS GPWClaimCount1, 
0 AS GPWClaimCount2, 
0 AS GPWClaimCount3, 
0 AS GPWClaimCount4, 
0 AS GPWClaimCount5, 
0 AS GPWClaimCount6, 
0 AS GPWClaimCount7, 
0 AS GPWClaimCount8, 
0 AS GPWClaimCount9, 
0 AS GPWClaimCount10, 
0 AS GPWClaimCount11, 
0 AS GPWClaimCount12, 
0 AS GPWClaimCount13, 
0 AS GPWClaimCount14, 
0 AS GPWClaimCount15,
0 AS GPWClaimCount16, 
0 AS GPWClaimCount17, 
0 AS GPWClaimCount18, 
0 AS GPWClaimCount19, 
0 AS GPWClaimCount20, 
0 AS GPWClaimCount21, 
0 AS GPWClaimCount22, 
0 AS GPWClaimCount23, 
0 AS GPWClaimCount24, 
0 AS GPWClaimCount25, 
0 AS GPWClaimCount26, 
0 AS GPWClaimCount27,
0 AS GPWClaimCount28, 
0 AS GPWClaimCount29, 
0 AS GPWClaimCount30, 
0 AS GPWClaimCount31, 
0 AS GPWClaimCount32, 
0 AS GPWClaimCount33, 
0 AS GPWClaimCount34, 
0 AS GPWClaimCount35, 
0 AS GPWClaimCount36, 
0 AS GPWClaimCount37, 
0 AS GPWClaimCount38, 
0 AS GPWClaimCount39, 
0 AS GPWClaimCount40 
FROM     dbo.GPWClaims 
--2/7/2023: Filtering done at summary level now
--WHERE 
--(
--(((GPWClaims.GPWClaimDate<=@ValDate) 
--AND (GPWClaims.GPWRelativeClaimQtr)>0) 
--AND (GPWClaims.GPWClaimCount=1) 
--AND ((GPWClaims.GPWEffectiveDate)<=@ValDate) 
--AND ((GPWClaims.GPWTermMonths)>0 
--And (GPWClaims.GPWTermMonths)<121) 
--AND ((GPWClaims.GPWContractCount)=1)
--and ((GPWClaims.GPWActiveReserve)>0)) 
--OR (((GPWClaims.GPWClaimDate)<=@ValDate) 
--AND ((GPWClaims.GPWRelativeClaimQtr)>0) 
--AND ((GPWClaims.GPWClaimCount)=1) 
--AND ((GPWClaims.GPWEffectiveDate)<=@ValDate) 
--AND ((GPWClaims.GPWTermMonths)>0 
--And (GPWClaims.GPWTermMonths)<121) 
--AND ((GPWClaims.GPWContractCount)=1)
--and ((GPWClaims.GPWCancelReserve)>0))
--)


--Delete GPWClaimsData
--FROM     dbo.GPWClaimsData 
--LEFT OUTER JOIN dbo.[GAP_Claim_Descriptions_Summed_12_2022] ON 
--                  dbo.GPWClaimsData.Claim_Number = dbo.[GAP_Claim_Descriptions_Summed_12_2022].[Claim No] AND 
--                  dbo.GPWClaimsData.Contract_Id = dbo.[GAP_Claim_Descriptions_Summed_12_2022].[Contract ID]
--Where ((dbo.GPWClaimsData.[GPWClaimDate] > CONVERT(DATETIME, '2017-08-24 00:00:00', 102) AND dbo.GPWClaimsData.[GPWClaimDate] < CONVERT(DATETIME, '2017-09-05 00:00:00', 102)) AND 
--                  (dbo.[GAP_Claim_Descriptions_Summed_12_2022].[Loss Cause Desc] = N'GAP Buyout - Flood'))

--IR 2/16/22 -- Added to break out claims that are split between a warehoused reinsurer and a non warehoused reinsurer. Also breaks out claims that are split between a gs re reinsurer and a non gs re reinsurer
if OBJECT_ID('MultipleReinsuranceTypesClaimData') is not null drop table MultipleReinsuranceTypesClaimData

SELECT 
	GPWClaimsData.[Contract_Id], 
	[Claim_Number] ,
	[GPWClaimDate],
	[GPWClaimQuarter],
	[GPWClaimQtr#],
	[GPWRelativeClaimQtr],
	[GPWClaimMiles], 
	[GPWActiveReserve]*COALESCE(Ceding_Percentage,1) [GPWActiveReserve],
	[GPWCancelReserve]*COALESCE(Ceding_Percentage,1) [GPWCancelReserve],
	COALESCE(Ceding_Percentage,1) [RecordCount],
	[GPWActiveClaimCount]*COALESCE(Ceding_Percentage,1) [GPWActiveClaimCount],
	[GPWCancelClaimCount]*COALESCE(Ceding_Percentage,1) [GPWCancelClaimCount],
	[GPWClaimCount]*COALESCE(Ceding_Percentage,1) [GPWClaimCount],
	[GPWActiveClaims]*COALESCE(Ceding_Percentage,1) [GPWActiveClaims],
	[GPWCancelClaims]*COALESCE(Ceding_Percentage,1) [GPWCancelClaims],
	[GPWClaims]*COALESCE(Ceding_Percentage,1) [GPWClaims],
	[Amount_Paid]*COALESCE(Ceding_Percentage,1) [Amount_Paid],
	[GPWObligor],
	[GPWCoverage],
	[GPW N/U/P],
	[GPWEffectiveDate],
	[GPWEffectiveMiles],
	[GPWTermMonths],
	[GPWTermMiles],
	[GPWCancelDate],
	[GPWCancelMiles],
	[GPWEffectiveQuarter],
	[GPWEffectiveQtr#],
	[GPWEffectiveYear],
	[GPWExpireDate],
	[GPWExpireMiles],
	[GPWAgg_VSC_MBI],
	[GPWAgg_GAP],
	[GPWAgg_SNV],
	[GPWAgg_CCC],
	[GPWAgg_TEC],
	[GPWAgg_MTNG] ,
	[GPWAgg_LTW] ,
	[GPWAgg_SDC] ,
	[GPWAgg_ANCL] ,
	[GPWSentruityInsured],
	MultipleReinsuranceTypesContract.New_GPWReinsurer GPWReinsurer,
	[GPWCancelQuarter],
	[GPWCancelQtr#],
	[GPWRelativeCancelQtr],
	[GPWFlatCancel],
	[GPWContractCount]*COALESCE(Ceding_Percentage,1) [GPWContractCount],
	[GPWCancelCount]*COALESCE(Ceding_Percentage,1) [GPWCancelCount],
	[GPWClaims1],
	[GPWClaims2],
	[GPWClaims3],
	[GPWClaims4],
	[GPWClaims5],
	[GPWClaims6],
	[GPWClaims7],
	[GPWClaims8],
	[GPWClaims9],
	[GPWClaims10],
	[GPWClaims11],
	[GPWClaims12],
	[GPWClaims13],
	[GPWClaims14],
	[GPWClaims15],
	[GPWClaims16],
	[GPWClaims17],
	[GPWClaims18],
	[GPWClaims19],
	[GPWClaims20],
	[GPWClaims21],
	[GPWClaims22],
	[GPWClaims23],
	[GPWClaims24],
	[GPWClaims25],
	[GPWClaims26],
	[GPWClaims27],
	[GPWClaims28],
	[GPWClaims29],
	[GPWClaims30],
	[GPWClaims31],
	[GPWClaims32],
	[GPWClaims33],
	[GPWClaims34],
	[GPWClaims35],
	[GPWClaims36],
	[GPWClaims37],
	[GPWClaims38],
	[GPWClaims39],
	[GPWClaims40],
	[GPWClaimCount1],
	[GPWClaimCount2],
	[GPWClaimCount3],
	[GPWClaimCount4],
	[GPWClaimCount5],
	[GPWClaimCount6],
	[GPWClaimCount7],
	[GPWClaimCount8],
	[GPWClaimCount9],
	[GPWClaimCount10],
	[GPWClaimCount11],
	[GPWClaimCount12],
	[GPWClaimCount13],
	[GPWClaimCount14],
	[GPWClaimCount15],
	[GPWClaimCount16],
	[GPWClaimCount17],
	[GPWClaimCount18],
	[GPWClaimCount19],
	[GPWClaimCount20],
	[GPWClaimCount21],
	[GPWClaimCount22],
	[GPWClaimCount23],
	[GPWClaimCount24],
	[GPWClaimCount25],
	[GPWClaimCount26],
	[GPWClaimCount27],
	[GPWClaimCount28],
	[GPWClaimCount29],
	[GPWClaimCount30],
	[GPWClaimCount31],
	[GPWClaimCount32],
	[GPWClaimCount33],
	[GPWClaimCount34],
	[GPWClaimCount35],
	[GPWClaimCount36],
	[GPWClaimCount37],
	[GPWClaimCount38],
	[GPWClaimCount39],
	[GPWClaimCount40]
	into MultipleReinsuranceTypesClaimData
	from GPWClaimsData
	inner join MultipleReinsuranceTypesContract on GPWClaimsData.Contract_Id = MultipleReinsuranceTypesContract.Contract_Id

	delete GPWClaimsData
	from GPWClaimsData
	inner join (select MultipleReinsuranceTypesContract.Contract_Id from MultipleReinsuranceTypesContract group by MultipleReinsuranceTypesContract.Contract_Id) multiplereinsurancetypecontracts on multiplereinsurancetypecontracts.Contract_Id = GPWClaimsData.Contract_Id

	insert into GPWClaimsData
	select *
	from MultipleReinsuranceTypesClaimData

GO
