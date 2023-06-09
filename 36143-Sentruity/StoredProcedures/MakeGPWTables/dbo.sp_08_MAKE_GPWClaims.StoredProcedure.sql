USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_08_MAKE_GPWClaims]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_08_MAKE_GPWClaims] AS

declare @valdate date = (select ValDate from Tbl_DBValues)

IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GPWClaims')
	DROP TABLE GPWClaims
CREATE TABLE [GPWClaims] (
[Contract_Id] varchar(255) NULL,
[Insurance_Carrier] varchar (50) NULL, 
[Contract_Number] varchar (50) NULL, 
[Claim_Status] varchar (255) NULL, 
[Claim_Number] varchar (50) NULL, 
[Reported_Date] datetime NULL, 
[Date_Loss_Occurred] datetime NULL,
[Odometer_At_Time_of_Loss] int NULL, 
[Amount_Paid] float NULL, 
[Date_Claim_Detail_Paid] datetime NULL, 
[GPWClaimDate] datetime NULL, 
[GPWClaimQuarter] varchar (50) NULL, 
[GPWClaimQtr#] int NULL, 
[GPWRelativeClaimQtr] int NULL, 
[GPWClaimMiles] int NULL, 
[GPWActiveClaimCount] int NULL, 
[GPWCancelClaimCount] int NULL, 
[GPWClaimCount] int NULL, 
[GPWActiveClaims] float NULL, 
[GPWCancelClaims] float NULL, 
[GPWClaims] float NULL, 
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
[GPWContractCount] int NULL, 
[GPWCancelCount] int NULL, 
[GPWPlanID] varchar (50) NULL, 
[GPWActiveReserve] float NULL, 
[GPWCancelReserve] float NULL ,
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
[GPWDealer] varchar (50) NULL)

INSERT INTO GPWClaims(
[Contract_Id] ,
[Insurance_Carrier] , 
[Contract_Number] , 
[Claim_Status] , 
[Claim_Number] , 
[Reported_Date] , 
[Date_Loss_Occurred] ,
[Odometer_At_Time_of_Loss] , 
[Amount_Paid] , 
[Date_Claim_Detail_Paid]  ,
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
[GPWDealer]
 )
SELECT     
[Contract_Id] ,
[Insurance_Carrier] , 
[Contract_Number] , 
[Claim_Status] , 
[Claim_Number] , 
[Reported_Date] , 
[Date_Loss_Occurred], 
[Odometer_At_Time_of_Loss] , 
[Amount_Paid] , 
[Date_Claim_Detail_Paid],
'' AS [GPWAgg_VSC_MBI],
'' AS [GPWAgg_GAP],
'' AS [GPWAgg_SNV],
'' AS [GPWAgg_CCC],
'' AS [GPWAgg_TEC],
'' AS [GPWAgg_MTNG] ,
'' AS [GPWAgg_LTW] ,
'' AS [GPWAgg_SDC] ,
'' AS [GPWAgg_ANCL] ,
0 as [GPWSentruityInsured],
'' AS [GPWReinsurer],
'' as [GPWDealer]
FROM ClaimsSummed 

INSERT INTO GPWClaims(
[Contract_Id] ,
[Insurance_Carrier] , 
[Contract_Number] , 
[Claim_Status] , 
[Claim_Number] , 
[Reported_Date] , 
[Date_Loss_Occurred] ,
[Odometer_At_Time_of_Loss] , 
[Amount_Paid] , 
[Date_Claim_Detail_Paid]  ,
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
[GPWDealer]
 )
 SELECT     
ltrim(rtrim(RawData_Claims_TriPac.Contract)) + '_Tripac' as [Contract_Id] ,
'TRIPAC' , 
RawData_Claims_TriPac.Contract as [Contract_Number] , 
Status as [Claim_Status] , 
[Claim ID] as [Claim_Number] , 
@valdate as [Reported_Date] , 
[Claim Date] as [Date_Loss_Occurred], 
0 as [Odometer_At_Time_of_Loss] , 
sum(Amount) as [Amount_Paid] , 
[Claim Date] as [Date_Claim_Detail_Paid],
'' AS [GPWAgg_VSC_MBI],
'' AS [GPWAgg_GAP],
'' AS [GPWAgg_SNV],
'' AS [GPWAgg_CCC],
'' AS [GPWAgg_TEC],
'' AS [GPWAgg_MTNG] ,
'' AS [GPWAgg_LTW] ,
'' AS [GPWAgg_SDC] ,
'' AS [GPWAgg_ANCL] ,
0 as [GPWSentruityInsured],
'' AS [GPWReinsurer],
'' as [GPWDealer]
FROM RawData_Claims_TriPac
inner join (select Contract from RawData_Contracts_TriPac where RawData_Contracts_TriPac.Status <> 'Cancelled' group by Contract) Contracts on RawData_Claims_TriPac.Contract = Contracts.Contract
group by RawData_Claims_TriPac.Contract, Status, [Claim ID], [Claim Date]

UPDATE GPWClaims
SET GPWClaimDate = [Date_Loss_Occurred] --12/31/2017 GAP Claims on paid basis
UPDATE GPWClaims
SET [GPWClaimQuarter]=' '
UPDATE GPWClaims
SET [GPWClaimQtr#]=0 
UPDATE GPWClaims
SET [GPWRelativeClaimQtr] =0
UPDATE GPWClaims
SET [GPWClaimMiles] =[Odometer_At_Time_of_Loss] 
UPDATE GPWClaims
SET [GPWActiveClaimCount]=0
UPDATE GPWClaims
SET [GPWCancelClaimCount] =0 
UPDATE GPWClaims
SET [GPWClaimCount]=0
UPDATE GPWClaims
SET [GPWActiveClaims]=0
UPDATE GPWClaims
SET [GPWCancelClaims] =0 
UPDATE GPWClaims
SET [GPWClaims] =0 


update GPWClaims
set GPWObligor=dbo.GPWContracts.GPWObligor
, GPWCoverage=dbo.GPWContracts.GPWCoverage
, [GPW N/U/P]=dbo.GPWContracts.[GPW N/U/P]
, GPWEffectiveDate=dbo.GPWContracts.GPWEffectiveDate
, GPWEffectiveMiles=dbo.GPWContracts.GPWEffectiveMiles
, GPWTermMonths=dbo.GPWContracts.GPWTermMonths
, GPWTermMiles=dbo.GPWContracts.GPWTermMiles
, GPWCancelDate=dbo.GPWContracts.GPWCancelDate 
, GPWCancelMiles=dbo.GPWContracts.GPWCancelMiles 
, GPWEffectiveQuarter=dbo.GPWContracts.GPWEffectiveQuarter 
, [GPWEffectiveQtr#]=dbo.GPWContracts.[GPWEffectiveQtr#]
, GPWEffectiveYear=dbo.GPWContracts.GPWEffectiveYear 
, GPWExpireDate=dbo.GPWContracts.GPWExpireDate
, GPWExpireMiles=dbo.GPWContracts.GPWExpireMiles 
, GPWCancelQuarter=dbo.GPWContracts.GPWCancelQuarter 
, [GPWCancelQtr#]=dbo.GPWContracts.[GPWCancelQtr#] 
, GPWRelativeCancelQtr=dbo.GPWContracts.GPWRelativeCancelQtr
, [GPWFlatCancel]=dbo.GPWContracts.[GPWFlatCancel] 
, GPWContractCount=dbo.GPWContracts.[GPWContractCount] 
, GPWCancelCount=dbo.GPWContracts.[GPWCancelCount] 
, GPWPlanID=dbo.GPWContracts.[GPWPlanID] 
, GPWActiveReserve=dbo.GPWContracts.[GPWActiveReserve] 
, GPWCancelReserve=dbo.GPWContracts.[GPWCancelReserve] 
, GPWClaims.GPWAgg_VSC_MBI = GPWContracts.GPWAgg_VSC_MBI
, GPWClaims.GPWAgg_GAP = GPWContracts.GPWAgg_GAP
, GPWClaims.GPWAgg_SNV = GPWContracts.GPWAgg_SNV
, GPWClaims.GPWAgg_CCC = GPWContracts.GPWAgg_CCC
, GPWClaims.GPWAgg_TEC = GPWContracts.GPWAgg_TEC
, GPWClaims.GPWAgg_MTNG = GPWContracts.GPWAgg_MTNG
, GPWClaims.GPWAgg_LTW = GPWContracts.GPWAgg_LTW
, GPWClaims.GPWAgg_SDC = GPWContracts.GPWAgg_SDC
, GPWClaims.GPWAgg_ANCL = GPWContracts.GPWAgg_ANCL
, GPWClaims.GPWSentruityInsured = GPWContracts.GPWSentruityInsured
, GPWClaims.GPWReinsurer = GPWContracts.GPWReinsurer
, GPWClaims.[GPWDealer] = GPWContracts.[GPWDealer]
, GPWClaims.Contract_Number = GPWContracts.Contract_Number
from GPWClaims left join GPWContracts on GPWClaims.Contract_Id = GPWContracts.Contract_Id


GO
