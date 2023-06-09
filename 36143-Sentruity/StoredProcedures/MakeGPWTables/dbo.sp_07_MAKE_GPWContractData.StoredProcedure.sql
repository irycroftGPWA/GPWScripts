USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_07_MAKE_GPWContractData]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_07_MAKE_GPWContractData] AS

DECLARE @BegDate AS DATE
SET @BegDate = (SELECT BegDate FROM TBL_DBVALUES)
DECLARE @ValDate AS DATE
SET @ValDate = (SELECT ValDate FROM TBL_DBVALUES)

IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GPWContractData')
	DROP TABLE GPWContractData
/*MAKE SURE GPW MILES COLUMNS ARE FLOATS*/
CREATE TABLE [GPWContractData] (
Contract_Id varchar (50) NULL, 
Contract_Number nvarchar (255) NULL,
[Insurance_Carrier] nvarchar (255) NULL,
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
[GPWCancelQuarter] varchar (50) NULL, 
[GPWCancelQtr#] int NULL, 
[GPWRelativeCancelQtr] int NULL, 
[GPWFlatCancel] varchar (50) NULL, 
[RecordCount] float NULL,
[GPWContractCount] float NULL, 
[GPWCancelCount] float NULL, 
[GPWActiveReserve] float NULL, 
[GPWCancelReserve] float NULL, 
[GPWSentruityNetPrem] float NULL,
[GPWSentruityEarnedPrem] float NULL,
[GPWSentruityUnearnedPrem] float NULL,
[GPWClaims] float NULL,
[GPWEstimatedAge] float NULL, 
[GPWMMEarnedPre] float NULL, 
[GPWEstimatedMiles] float NULL, 
[GPWMMEarnedPost] float NULL, 
[GPWMMEarnedTotal%] float NULL, 
[GPWMMEarned] float NULL, 
[EarnedQuarters] float NULL,
[Earned%] float NULL,
[PlanGroup] varchar (50) NULL, 
[GPWSentruityInsured] int NULL,
[GPWReinsurer] varchar (255) NULL,
[GPWAgg_VSC_MBI] varchar (50) NULL,
[GPWAgg_GAP] varchar (50) NULL,
[GPWAgg_SNV] varchar (50) NULL,
[GPWAgg_CCC] varchar (50) NULL,
[GPWAgg_TEC] varchar (50) NULL,
[GPWAgg_MTNG] varchar (50) NULL,
[GPWAgg_LTW] varchar (50) NULL,
[GPWAgg_SDC] varchar (50) NULL,
[GPWAgg_ANCL] varchar (50) NULL,
[GPWCancelCount1] float NULL, 
[GPWCancelCount2] float NULL, 
[GPWCancelCount3] float NULL, 
[GPWCancelCount4] float NULL, 
[GPWCancelCount5] float NULL, 
[GPWCancelCount6] float NULL, 
[GPWCancelCount7] float NULL, 
[GPWCancelCount8] float NULL, 
[GPWCancelCount9] float NULL, 
[GPWCancelCount10] float NULL, 
[GPWCancelCount11] float NULL, 
[GPWCancelCount12] float NULL, 
[GPWCancelCount13] float NULL, 
[GPWCancelCount14] float NULL, 
[GPWCancelCount15] float NULL, 
[GPWCancelCount16] float NULL, 
[GPWCancelCount17] float NULL, 
[GPWCancelCount18] float NULL, 
[GPWCancelCount19] float NULL, 
[GPWCancelCount20] float NULL, 
[GPWCancelCount21] float NULL, 
[GPWCancelCount22] float NULL, 
[GPWCancelCount23] float NULL, 
[GPWCancelCount24] float NULL, 
[GPWCancelCount25] float NULL, 
[GPWCancelCount26] float NULL, 
[GPWCancelCount27] float NULL, 
[GPWCancelCount28] float NULL, 
[GPWCancelCount29] float NULL, 
[GPWCancelCount30] float NULL, 
[GPWCancelCount31] float NULL, 
[GPWCancelCount32] float NULL, 
[GPWCancelCount33] float NULL, 
[GPWCancelCount34] float NULL, 
[GPWCancelCount35] float NULL, 
[GPWCancelCount36] float NULL, 
[GPWCancelCount37] float NULL, 
[GPWCancelCount38] float NULL, 
[GPWCancelCount39] float NULL, 
[GPWCancelCount40] float NULL,
[GPWCancelRx1] float NULL, 
[GPWCancelRx2] float NULL, 
[GPWCancelRx3] float NULL, 
[GPWCancelRx4] float NULL, 
[GPWCancelRx5] float NULL, 
[GPWCancelRx6] float NULL, 
[GPWCancelRx7] float NULL, 
[GPWCancelRx8] float NULL, 
[GPWCancelRx9] float NULL, 
[GPWCancelRx10] float NULL, 
[GPWCancelRx11] float NULL, 
[GPWCancelRx12] float NULL, 
[GPWCancelRx13] float NULL, 
[GPWCancelRx14] float NULL, 
[GPWCancelRx15] float NULL, 
[GPWCancelRx16] float NULL, 
[GPWCancelRx17] float NULL, 
[GPWCancelRx18] float NULL, 
[GPWCancelRx19] float NULL, 
[GPWCancelRx20] float NULL, 
[GPWCancelRx21] float NULL, 
[GPWCancelRx22] float NULL, 
[GPWCancelRx23] float NULL, 
[GPWCancelRx24] float NULL, 
[GPWCancelRx25] float NULL, 
[GPWCancelRx26] float NULL, 
[GPWCancelRx27] float NULL, 
[GPWCancelRx28] float NULL, 
[GPWCancelRx29] float NULL, 
[GPWCancelRx30] float NULL, 
[GPWCancelRx31] float NULL, 
[GPWCancelRx32] float NULL, 
[GPWCancelRx33] float NULL, 
[GPWCancelRx34] float NULL, 
[GPWCancelRx35] float NULL, 
[GPWCancelRx36] float NULL, 
[GPWCancelRx37] float NULL, 
[GPWCancelRx38] float NULL, 
[GPWCancelRx39] float NULL, 
[GPWCancelRx40] float NULL )
INSERT INTO GPWContractData(
Contract_Id,
Contract_Number,
Insurance_Carrier,
GPWObligor,
GPWCoverage,
[GPW N/U/P],
GPWEffectiveDate,
GPWEffectiveMiles,
GPWTermMonths,
GPWTermMiles,
GPWCancelDate,
GPWCancelMiles,
GPWEffectiveQuarter,
[GPWEffectiveQtr#],
GPWEffectiveYear,
GPWExpireDate,
GPWExpireMiles,
GPWCancelQuarter,
[GPWCancelQtr#],
GPWRelativeCancelQtr,
GPWFlatCancel,
[RecordCount],
GPWContractCount,
GPWCancelCount,
GPWActiveReserve,
GPWCancelReserve,
GPWSentruityNetPrem,
GPWSentruityEarnedPrem,
GPWSentruityUnearnedPrem,
GPWClaims,
GPWEstimatedAge,
GPWMMEarnedPre,
GPWEstimatedMiles,
GPWMMEarnedPost,
[GPWMMEarnedTotal%],
GPWMMEarned,
[EarnedQuarters],
[Earned%],
[PlanGroup],
[GPWSentruityInsured],
[GPWReinsurer],
[GPWAgg_VSC_MBI],
[GPWAgg_GAP],
[GPWAgg_SNV],
[GPWAgg_CCC],
[GPWAgg_TEC],
[GPWAgg_MTNG] ,
[GPWAgg_LTW] ,
[GPWAgg_SDC] ,
[GPWAgg_ANCL],
GPWCancelCount1, 
GPWCancelCount2, 
GPWCancelCount3, 
GPWCancelCount4, 
GPWCancelCount5, 
GPWCancelCount6, 
GPWCancelCount7, 
GPWCancelCount8, 
GPWCancelCount9, 
GPWCancelCount10, 
GPWCancelCount11,
GPWCancelCount12, 
GPWCancelCount13, 
GPWCancelCount14, 
GPWCancelCount15, 
GPWCancelCount16, 
GPWCancelCount17, 
GPWCancelCount18, 
GPWCancelCount19, 
GPWCancelCount20, 
GPWCancelCount21, 
GPWCancelCount22, 
GPWCancelCount23, 
GPWCancelCount24, 
GPWCancelCount25, 
GPWCancelCount26, 
GPWCancelCount27, 
GPWCancelCount28, 
GPWCancelCount29, 
GPWCancelCount30, 
GPWCancelCount31, 
GPWCancelCount32, 
GPWCancelCount33, 
GPWCancelCount34, 
GPWCancelCount35, 
GPWCancelCount36, 
GPWCancelCount37, 
GPWCancelCount38, 
GPWCancelCount39, 
GPWCancelCount40,
[GPWCancelRx1] , 
[GPWCancelRx2] , 
[GPWCancelRx3] , 
[GPWCancelRx4] , 
[GPWCancelRx5] , 
[GPWCancelRx6] , 
[GPWCancelRx7] , 
[GPWCancelRx8] , 
[GPWCancelRx9] , 
[GPWCancelRx10] , 
[GPWCancelRx11] , 
[GPWCancelRx12] , 
[GPWCancelRx13] , 
[GPWCancelRx14] , 
[GPWCancelRx15] , 
[GPWCancelRx16] , 
[GPWCancelRx17] , 
[GPWCancelRx18] , 
[GPWCancelRx19] , 
[GPWCancelRx20] , 
[GPWCancelRx21] , 
[GPWCancelRx22] , 
[GPWCancelRx23] , 
[GPWCancelRx24] , 
[GPWCancelRx25] , 
[GPWCancelRx26] , 
[GPWCancelRx27] , 
[GPWCancelRx28] , 
[GPWCancelRx29] , 
[GPWCancelRx30] , 
[GPWCancelRx31] , 
[GPWCancelRx32] , 
[GPWCancelRx33] , 
[GPWCancelRx34] , 
[GPWCancelRx35] , 
[GPWCancelRx36] , 
[GPWCancelRx37] , 
[GPWCancelRx38] , 
[GPWCancelRx39] , 
[GPWCancelRx40]  )
SELECT 
Contract_Id AS [Contract_Id],
Contract_Number as [Contract_Number],
[Insurance_Carrier] as [Insurance_Carrier],
GPWObligor AS GPWObligor,
GPWCoverage AS GPWCoverage,
[GPW N/U/P] AS [GPW N/U/P],
GPWEffectiveDate AS GPWEffectiveDate,
GPWEffectiveMiles AS GPWEffectiveMiles,
GPWTermMonths AS GPWTermMonths,
GPWTermMiles AS GPWTermMiles,
GPWCancelDate AS GPWCancelDate,
GPWCancelMiles AS GPWCancelMiles,
GPWEffectiveQuarter AS GPWEffectiveQuarter,
[GPWEffectiveQtr#] AS [GPWEffectiveQtr#],
GPWEffectiveYear AS GPWEffectiveYear,
GPWExpireDate AS GPWExpireDate,
GPWExpireMiles AS GPWExpireMiles,
GPWCancelQuarter AS GPWCancelQuarter,
[GPWCancelQtr#] AS [GPWCancelQtr#],
GPWRelativeCancelQtr AS GPWRelativeCancelQtr,
GPWFlatCancel AS GPWFlatCancel,
1 as [RecordCount],
GPWContractCount AS GPWContractCount,
GPWCancelCount AS GPWCancelCount,
GPWActiveReserve AS GPWActiveReserve,
GPWCancelReserve AS GPWCancelReserve,
GPWSentruityNetPrem as GPWSentruityNetPrem,
GPWSentruityEarnedPrem as GPWSentruityEarnedPrem,
GPWSentruityUnearnedPrem as GPWSentruityUnearnedPrem,
GPWClaims as GPWClaims,
GPWEstimatedAge AS GPWEstimatedAge,
GPWMMEarnedPre AS GPWMMEarnedPre,
GPWEstimatedMiles AS GPWEstimatedMiles,
GPWMMEarnedPost AS GPWMMEarnedPost,
[GPWMMEarnedTotal%] AS [GPWMMEarnedTotal%],
GPWMMEarned AS GPWMMEarned,
[EarnedQuarters],
[Earned%],
[PlanGroup] AS [PlanGroup],
[GPWSentruityInsured] AS [GPWSentruityInsured],
[GPWReinsurer] AS [GPWReinsurer],
[GPWAgg_VSC_MBI],
[GPWAgg_GAP],
[GPWAgg_SNV],
[GPWAgg_CCC],
[GPWAgg_TEC],
[GPWAgg_MTNG] ,
[GPWAgg_LTW] ,
[GPWAgg_SDC] ,
[GPWAgg_ANCL],
0 AS GPWCancelCount1, 
0 AS GPWCancelCount2, 
0 AS GPWCancelCount3, 
0 AS GPWCancelCount4, 
0 AS GPWCancelCount5, 
0 AS GPWCancelCount6, 
0 AS GPWCancelCount7, 
0 AS GPWCancelCount8, 
0 AS GPWCancelCount9, 
0 AS GPWCancelCount10, 
0 AS GPWCancelCount11,
0 AS GPWCancelCount12, 
0 AS GPWCancelCount13, 
0 AS GPWCancelCount14, 
0 AS GPWCancelCount15, 
0 AS GPWCancelCount16, 
0 AS GPWCancelCount17, 
0 AS GPWCancelCount18, 
0 AS GPWCancelCount19, 
0 AS GPWCancelCount20, 
0 AS GPWCancelCount21, 
0 AS GPWCancelCount22, 
0 AS GPWCancelCount23, 
0 AS GPWCancelCount24, 
0 AS GPWCancelCount25, 
0 AS GPWCancelCount26, 
0 AS GPWCancelCount27, 
0 AS GPWCancelCount28, 
0 AS GPWCancelCount29, 
0 AS GPWCancelCount30, 
0 AS GPWCancelCount31, 
0 AS GPWCancelCount32, 
0 AS GPWCancelCount33, 
0 AS GPWCancelCount34, 
0 AS GPWCancelCount35, 
0 AS GPWCancelCount36, 
0 AS GPWCancelCount37, 
0 AS GPWCancelCount38, 
0 AS GPWCancelCount39, 
0 AS GPWCancelCount40,
0 AS GPWCancelRx1, 
0 AS GPWCancelRx2, 
0 AS GPWCancelRx3, 
0 AS GPWCancelRx4, 
0 AS GPWCancelRx5, 
0 AS GPWCancelRx6, 
0 AS GPWCancelRx7, 
0 AS GPWCancelRx8, 
0 AS GPWCancelRx9, 
0 AS GPWCancelRx10, 
0 AS GPWCancelRx11,
0 AS GPWCancelRx12, 
0 AS GPWCancelRx13, 
0 AS GPWCancelRx14, 
0 AS GPWCancelRx15, 
0 AS GPWCancelRx16, 
0 AS GPWCancelRx17, 
0 AS GPWCancelRx18, 
0 AS GPWCancelRx19, 
0 AS GPWCancelRx20, 
0 AS GPWCancelRx21, 
0 AS GPWCancelRx22, 
0 AS GPWCancelRx23, 
0 AS GPWCancelRx24, 
0 AS GPWCancelRx25, 
0 AS GPWCancelRx26, 
0 AS GPWCancelRx27, 
0 AS GPWCancelRx28, 
0 AS GPWCancelRx29, 
0 AS GPWCancelRx30, 
0 AS GPWCancelRx31, 
0 AS GPWCancelRx32, 
0 AS GPWCancelRx33, 
0 AS GPWCancelRx34, 
0 AS GPWCancelRx35, 
0 AS GPWCancelRx36, 
0 AS GPWCancelRx37, 
0 AS GPWCancelRx38, 
0 AS GPWCancelRx39, 
0 AS GPWCancelRx40 
 
FROM GPWContracts
--Filtering Done at the summary level now
--WHERE (((GPWContracts.GPWEffectiveDate) between @begDate and @valdate) 
--AND ((GPWContracts.GPWTermMonths)>0 
--And (GPWContracts.GPWTermMonths)<121) 
--AND ((GPWContracts.GPWRelativeCancelQtr)>=0) 
--AND ((GPWContracts.GPWContractCount)=1) 
--AND ((GPWContracts.GPWActiveReserve)>0)) 
--OR (((GPWContracts.GPWEffectiveDate) between @begDate and @valdate) 
--AND ((GPWContracts.GPWTermMonths)>0 
--And (GPWContracts.GPWTermMonths)<121) 
--AND ((GPWContracts.GPWRelativeCancelQtr)>=0) 
--AND ((GPWContracts.GPWContractCount)=1) 
--AND ((GPWContracts.GPWCancelReserve)>0))




----Applying ricshares to warehoused contracts
--if OBJECT_ID('WarehousedContracts') is not null drop table WarehousedContracts

--CREATE Table WarehousedContracts 
--(Contract_Id varchar(50), Ceding_Percentage float)

--insert into WarehousedContracts
--select GPWContractData.Contract_Id, Ceding_Percentage
--from GPWContractData
--left join SentruityContractSplit2021 on GPWContractData.Contract_Id = SentruityContractSplit2021.Contract_Id
--where (Reinsurance_Company_Name = 'Family 3 CFC Warehouse') 
--		or (Reinsurance_Company_Name = 'Toyota of Boerne APP GS Re 3 Warehouse')
--group by GPWContractData.Contract_Id, Ceding_Percentage	

--update GPWContractData
--set GPWContractCount = GPWContractCount*COALESCE(Ceding_Percentage,1)
--, GPWCancelCount = GPWCancelCount*coalesce(Ceding_Percentage,1)
--, GPWActiveReserve = GPWActiveReserve*COALESCE(Ceding_Percentage,1)
--, GPWCancelReserve = GPWCancelReserve*COALESCE(Ceding_Percentage,1)
--from GPWContractData
--inner join WarehousedContracts on GPWContractData.Contract_Id = WarehousedContracts.Contract_Id

--IR 2/16/22 -- Added to break out contracts that are split between a warehoused reinsurer and a non warehoused reinsurer. Also breaks out contracts that are split between a gs re reinsurer and a non gs re reinsurer
if OBJECT_ID('MultipleReinsuranceTypesContract') is not null drop table MultipleReinsuranceTypesContract

CREATE Table MultipleReinsuranceTypesContract
(Contract_Id varchar(50)
, Reinsurance_Company_Name varchar(255)
, GPWReinsurer varchar(255)
, New_GPWReinsurer varchar(255)
, Ceding_Percentage float)

insert into MultipleReinsuranceTypesContract 
select GPWContractData.Contract_Id
, split.Reinsurance_Company_Name
, GPWContractData.GPWReinsurer
, case when split.Reinsurance_Type = 'CFC' then split.Reinsurance_Company_Name 
	   else case when split.Reinsurance_Type = 'Warehouse' then 'Retained' 
				 when split.Reinsurance_Type = 'NCFC-GS Re 2' then 'GS Re2'
				 when split.Reinsurance_Type = 'NCFC-GS Re 3' then 'GS Re3'
				 else GPWContractData.GPWReinsurer end end New_GPWReinsurer
, split.Ceding_Percentage
from GPWContractData
left join GPWContracts on GPWContractData.Contract_Id = GPWContracts.Contract_Id
left join TBL_ProductTypes on TBL_ProductTypes.Carrier = GPWContracts.Insurance_Carrier
inner join SentruityContractSplit2022 split on GPWContractData.Contract_Id = split.Contract_Id
inner join Tbl_MultipleReinsuranceTypesByDealerCode on split.[Dealer No] = Tbl_MultipleReinsuranceTypesByDealerCode.Dealer_Number 
and Tbl_MultipleReinsuranceTypesByDealerCode.Product_Type = TBL_ProductTypes.Product_Type 
and GPWContractData.GPWEffectiveDate between Tbl_MultipleReinsuranceTypesByDealerCode.Start_Date and Tbl_MultipleReinsuranceTypesByDealerCode.End_Date
and GPWContractData.Insurance_Carrier <> 'TRIPAC'
order by split.Reinsurance_Company_Name

if OBJECT_ID('MultipleReinsuranceTypesContractData') is not null drop table MultipleReinsuranceTypesContractData

select 
  GPWContractData.[Contract_Id]
, [Contract_Number]
, [Insurance_Carrier]
, [GPWObligor]
, [GPWCoverage]
, [GPW N/U/P]
, [GPWEffectiveDate]
, [GPWEffectiveMiles]
, [GPWTermMonths]
, [GPWTermMiles]
, [GPWCancelDate]
, [GPWCancelMiles]
, [GPWEffectiveQuarter]
, [GPWEffectiveQtr#]
, [GPWEffectiveYear]
, [GPWExpireDate]
, [GPWExpireMiles]
, [GPWCancelQuarter]
, [GPWCancelQtr#]
, [GPWRelativeCancelQtr]
, [GPWFlatCancel]
, COALESCE(Ceding_Percentage,1) [RecordCount]
, [GPWContractCount]*COALESCE(Ceding_Percentage,1) [GPWContractCount]
, [GPWCancelCount]*COALESCE(Ceding_Percentage,1) [GPWCancelCount]
, [GPWActiveReserve]*COALESCE(Ceding_Percentage,1) [GPWActiveReserve]
, [GPWCancelReserve]*COALESCE(Ceding_Percentage,1) [GPWCancelReserve]
, GPWSentruityNetPrem*COALESCE(Ceding_Percentage,1) as [GPWSentruityNetPrem]
, GPWSentruityEarnedPrem*COALESCE(Ceding_Percentage,1) as [GPWSentruityEarnedPrem]
, GPWSentruityUnearnedPrem*COALESCE(Ceding_Percentage,1) as [GPWSentruityUnearnedPrem]
, GPWClaims as GPWClaims
, [GPWEstimatedAge]
, [GPWMMEarnedPre]
, [GPWEstimatedMiles]
, [GPWMMEarnedPost]
, [GPWMMEarnedTotal%]
, [GPWMMEarned]
, [EarnedQuarters]
, [Earned%]
, [PlanGroup]
, [GPWSentruityInsured]
, MultipleReinsuranceTypesContract.New_GPWReinsurer GPWReinsurer
, [GPWAgg_VSC_MBI]
, [GPWAgg_GAP]
, [GPWAgg_SNV]
, [GPWAgg_CCC]
, [GPWAgg_TEC]
, [GPWAgg_MTNG]
, [GPWAgg_LTW]
, [GPWAgg_SDC]
, [GPWAgg_ANCL]
,GPWCancelCount1, 
GPWCancelCount2, 
GPWCancelCount3, 
GPWCancelCount4, 
GPWCancelCount5, 
GPWCancelCount6, 
GPWCancelCount7, 
GPWCancelCount8, 
GPWCancelCount9, 
GPWCancelCount10, 
GPWCancelCount11,
GPWCancelCount12, 
GPWCancelCount13, 
GPWCancelCount14, 
GPWCancelCount15, 
GPWCancelCount16, 
GPWCancelCount17, 
GPWCancelCount18, 
GPWCancelCount19, 
GPWCancelCount20, 
GPWCancelCount21, 
GPWCancelCount22, 
GPWCancelCount23, 
GPWCancelCount24, 
GPWCancelCount25, 
GPWCancelCount26, 
GPWCancelCount27, 
GPWCancelCount28, 
GPWCancelCount29, 
GPWCancelCount30, 
GPWCancelCount31, 
GPWCancelCount32, 
GPWCancelCount33, 
GPWCancelCount34, 
GPWCancelCount35, 
GPWCancelCount36, 
GPWCancelCount37, 
GPWCancelCount38, 
GPWCancelCount39, 
GPWCancelCount40,
[GPWCancelRx1] , 
[GPWCancelRx2] , 
[GPWCancelRx3] , 
[GPWCancelRx4] , 
[GPWCancelRx5] , 
[GPWCancelRx6] , 
[GPWCancelRx7] , 
[GPWCancelRx8] , 
[GPWCancelRx9] , 
[GPWCancelRx10] , 
[GPWCancelRx11] , 
[GPWCancelRx12] , 
[GPWCancelRx13] , 
[GPWCancelRx14] , 
[GPWCancelRx15] , 
[GPWCancelRx16] , 
[GPWCancelRx17] , 
[GPWCancelRx18] , 
[GPWCancelRx19] , 
[GPWCancelRx20] , 
[GPWCancelRx21] , 
[GPWCancelRx22] , 
[GPWCancelRx23] , 
[GPWCancelRx24] , 
[GPWCancelRx25] , 
[GPWCancelRx26] , 
[GPWCancelRx27] , 
[GPWCancelRx28] , 
[GPWCancelRx29] , 
[GPWCancelRx30] , 
[GPWCancelRx31] , 
[GPWCancelRx32] , 
[GPWCancelRx33] , 
[GPWCancelRx34] , 
[GPWCancelRx35] , 
[GPWCancelRx36] , 
[GPWCancelRx37] , 
[GPWCancelRx38] , 
[GPWCancelRx39] , 
[GPWCancelRx40]  
into MultipleReinsuranceTypesContractData
from GPWContractData
inner join MultipleReinsuranceTypesContract on GPWContractData.Contract_Id = MultipleReinsuranceTypesContract.Contract_Id
where Insurance_Carrier <> 'TRIPAC'

delete GPWContractData
from GPWContractData
inner join (select MultipleReinsuranceTypesContract.Contract_Id from MultipleReinsuranceTypesContract group by MultipleReinsuranceTypesContract.Contract_Id) multiplereinsurancetypecontracts on multiplereinsurancetypecontracts.Contract_Id = GPWContractData.Contract_Id
where Insurance_Carrier <> 'TRIPAC'

insert into GPWContractData
select *
 from MultipleReinsuranceTypesContractData;
GO
