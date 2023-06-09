USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_00_e_MAKE_SentruityContractSplit2022]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_00_e_MAKE_SentruityContractSplit2022] AS


--There is 1 overlapping date range in porcsetupcomponents
--Dealer Bumber '03058', cedingcompany = 'SEN', date range 111 and 116
--Removing the 116 range as it starts later than 111. Might need to change if we do not reconcile to Trotter Reinsurance Company, Ltd.

delete from PORC_Setup_Components
where PORC_Setup_Components.Dealer_Number = '03058' and PORC_Setup_Components.Ceding_Company_Abr = 'SEN' and PORC_Setup_Components.Date_Range_ID = '116'

IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'SentruityContractSplit2022')
	DROP TABLE SentruityContractSplit2022

IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'SentruityContractSplit2022List')
	DROP TABLE SentruityContractSplit2022List

--Join to PORC_Setup_Components directly from GSFSContractDetail
--Join to DealerCodes table to bring in dealer codes to then join to setup components on dealercode, product type, contract sale date and CedingCompany = 'SEN'

;with ContractDealerCodes as (
	select GSFSContract_Detail.Contract_Number
	, GSFSContract_Detail.Contract_Id
	, GSFSContract_Detail.Contract_Sale_Date
	, GSFSContract_Detail.Insurance_Carrier
	, SentruityContractByDealerCode.[Dealer No]
	, TBL_ProductTypes.Product_Type
	from GSFSContract_Detail
	left join SentruityContractByDealerCode on GSFSContract_Detail.Contract_Number = SentruityContractByDealerCode.[Contract No] 
											and GSFSContract_Detail.Insurance_Carrier = SentruityContractByDealerCode.[Carrier Abr]
	left join TBL_ProductTypes on GSFSContract_Detail.Insurance_Carrier = TBL_ProductTypes.Carrier
	)
, ReinsuredContracts as (
	select Reinsurance_Dec_2022_ITD_By_Contract.Contract_No
	from Reinsurance_Dec_2022_ITD_By_Contract
	group by Reinsurance_Dec_2022_ITD_By_Contract.Contract_No
)
select ContractDealerCodes.Contract_Number
, ContractDealerCodes.Contract_Id
, ContractDealerCodes.[Dealer No]
, ContractDealerCodes.Insurance_Carrier
, PORC_Setup_Components.Reinsurance_Company_Name
, cast(PORC_Setup_Components.Ceding_Percentage as float) Ceding_Percentage
, PORC_Setup_Components.Ceding_Company_Abr
, PORC_Setup_Components.Reinsurance_Group_Name
, PORC_Setup_Components.Reinsurance_Type
, PORC_Setup_Components.Reinsurance_Type_ID
into SentruityContractSplit2022
from ContractDealerCodes
INNER join PORC_Setup_Components on ContractDealerCodes.[Dealer No] = PORC_Setup_Components.Dealer_Number
								and ContractDealerCodes.Product_Type = PORC_Setup_Components.Product_Type
								and ContractDealerCodes.Contract_Sale_Date BETWEEN PORC_Setup_Components.Start_Date and PORC_Setup_Components.End_Date
								and  PORC_Setup_Components.Ceding_Company_Abr = 'SEN'
inner join ReinsuredContracts on ContractDealerCodes.Contract_Number = ReinsuredContracts.Contract_No
--Remove carriers not in recap file
;with CarriersToInclude as (
select ltrim(rtrim(GSFS_PORC_Data_Extract.[Carrier ABR])) [Carrier ABR]
, GSFS_PORC_Data_Extract.[Dealer Number]
from GSFS_PORC_Data_Extract
where GSFS_PORC_Data_Extract.[Ceding Company Abr] = 'SEN'
group by GSFS_PORC_Data_Extract.[Carrier ABR]
, GSFS_PORC_Data_Extract.[Dealer Number]
)

delete from SentruityContractSplit2022
from SentruityContractSplit2022
left JOIN CarriersToInclude on CarriersToInclude.[Carrier ABR] =SentruityContractSplit2022.Insurance_Carrier
and CarriersToInclude.[Dealer Number] = SentruityContractSplit2022.[Dealer No]
where CarriersToInclude.[Carrier ABR] is null

--removing some contracts from the VSCESS product type that shouldnt be reinsured based on the porc_data_extract
delete from SentruityContractSplit2022
from SentruityContractSplit2022
left join GSFSContract_Detail on GSFSContract_Detail.Contract_Number = SentruityContractSplit2022.Contract_Number
where SentruityContractSplit2022.Insurance_Carrier = 'RRG'
and SentruityContractSplit2022.Reinsurance_Company_Name = 'Oxford GS Re2'
and SentruityContractSplit2022.[Dealer No] in ('23054')
and GSFSContract_Detail.Rate_Book not in ('2485')	

--Creating SentruityContractSplitList2022 which is just a list of reinsured contracts

;with ContractDealerCodes as (
	select GSFSContract_Detail.Contract_Number
	, GSFSContract_Detail.Contract_Id
	, GSFSContract_Detail.Contract_Sale_Date
	, GSFSContract_Detail.Insurance_Carrier
	, SentruityContractByDealerCode.[Dealer No]
	, TBL_ProductTypes.Product_Type
	from GSFSContract_Detail
	left join SentruityContractByDealerCode on GSFSContract_Detail.Contract_Number = SentruityContractByDealerCode.[Contract No] 
											and GSFSContract_Detail.Insurance_Carrier = SentruityContractByDealerCode.[Carrier Abr]
	left join TBL_ProductTypes on GSFSContract_Detail.Insurance_Carrier = TBL_ProductTypes.Carrier
	)
, ReinsuredContracts as (
	select Reinsurance_Dec_2022_ITD_By_Contract.Contract_No
	from Reinsurance_Dec_2022_ITD_By_Contract
	group by Reinsurance_Dec_2022_ITD_By_Contract.Contract_No
)
select ContractDealerCodes.Contract_Number
, ContractDealerCodes.Contract_Id
, ContractDealerCodes.[Dealer No]
, ContractDealerCodes.Insurance_Carrier
, PORC_Setup_Components.Reinsurance_Type
, PORC_Setup_Components.Reinsurance_Group_Name
, PORC_Setup_Components.Ceding_Company_Abr
, case when PORC_Setup_Components.Reinsurance_Company_Name in ('Family 2 Product Reinsurance Company, Ltd.', 'O S Ptrs Products reinsurance Company, Ltd.') then 'Family Group' else case when (PORC_Setup_Components.Reinsurance_Group_Name = '' or PORC_Setup_Components.Reinsurance_Group_Name is null) then PORC_Setup_Components.Reinsurance_Company_Name else PORC_Setup_Components.Reinsurance_Group_Name end end as Reinsurer
into SentruityContractSplit2022List
from ContractDealerCodes
INNER join PORC_Setup_Components on ContractDealerCodes.[Dealer No] = PORC_Setup_Components.Dealer_Number
								and ContractDealerCodes.Product_Type = PORC_Setup_Components.Product_Type
								and ContractDealerCodes.Contract_Sale_Date BETWEEN PORC_Setup_Components.Start_Date and PORC_Setup_Components.End_Date
								and  PORC_Setup_Components.Ceding_Company_Abr = 'SEN'
inner join ReinsuredContracts on ContractDealerCodes.Contract_Number = ReinsuredContracts.Contract_No
group by ContractDealerCodes.Contract_Number
, ContractDealerCodes.Contract_Id
, ContractDealerCodes.[Dealer No]
, ContractDealerCodes.Insurance_Carrier
, PORC_Setup_Components.Reinsurance_Type
, PORC_Setup_Components.Reinsurance_Group_Name
, PORC_Setup_Components.Ceding_Company_Abr
, case when PORC_Setup_Components.Reinsurance_Company_Name in ('Family 2 Product Reinsurance Company, Ltd.', 'O S Ptrs Products reinsurance Company, Ltd.') then 'Family Group' else case when (PORC_Setup_Components.Reinsurance_Group_Name = '' or PORC_Setup_Components.Reinsurance_Group_Name is null) then PORC_Setup_Components.Reinsurance_Company_Name else PORC_Setup_Components.Reinsurance_Group_Name end end

--Remove carriers not in recap file
;with CarriersToInclude as (
select ltrim(rtrim(GSFS_PORC_Data_Extract.[Carrier ABR])) [Carrier ABR]
, GSFS_PORC_Data_Extract.[Dealer Number]
from GSFS_PORC_Data_Extract
where GSFS_PORC_Data_Extract.[Ceding Company Abr] = 'SEN'
group by GSFS_PORC_Data_Extract.[Carrier ABR]
, GSFS_PORC_Data_Extract.[Dealer Number]
)

delete from SentruityContractSplit2022List
from SentruityContractSplit2022List
left JOIN CarriersToInclude on CarriersToInclude.[Carrier ABR] = SentruityContractSplit2022List.Insurance_Carrier
and CarriersToInclude.[Dealer Number] = SentruityContractSplit2022List.[Dealer No]
where CarriersToInclude.[Carrier ABR] is null

--removing some contracts from the VSCESS product type that shouldnt be reinsured based on the porc_data_extract
delete from SentruityContractSplit2022List
from SentruityContractSplit2022List
left join GSFSContract_Detail on GSFSContract_Detail.Contract_Number = SentruityContractSplit2022List.Contract_Number
where SentruityContractSplit2022List.Insurance_Carrier = 'RRG'
and SentruityContractSplit2022List.Reinsurer = 'Oxford GS Re2'
and SentruityContractSplit2022List.[Dealer No] in ('23054')
and GSFSContract_Detail.Rate_Book not in ('2485')	
GO
