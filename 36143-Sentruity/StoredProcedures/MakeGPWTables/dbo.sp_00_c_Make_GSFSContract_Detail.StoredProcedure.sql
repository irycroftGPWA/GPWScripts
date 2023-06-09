USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_00_c_Make_GSFSContract_Detail]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_00_c_Make_GSFSContract_Detail] AS
IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GSFSContract_Detail')
	DROP TABLE GSFSContract_Detail

DECLARE @ValDate AS DATE
SET @ValDate = (SELECT ValDate FROM TBL_DBVALUES)


Create Table GSFSContract_Detail(
Contract_Id varchar(255) Null,
Status_Id varchar(255) Null,
Insurance_Carrier varchar(255) Null,
Contract_Sale_Date datetime Null,
Production_Source varchar(255) Null,
New_Used varchar(255) Null,
Vehicle_Band varchar(255) Null,
Rate_Book varchar(255) Null,
Plan_Code varchar(255) Null,
Plan_Deductible float Null,
Contract_Number varchar(255) Null,
Dealer_Number varchar(255) Null,
Effective_Date datetime Null,
Expiration_Date datetime Null,
Contract_Term float Null,
Expiration_Time_Terms float Null,
Sale_Odometer float Null,
Expiration_Odometer float Null,
Expiration_Time_mileage float Null,
Make varchar(255) Null,
Model varchar(255) Null,
Model_Year varchar(255) Null,
Vehicle_Class varchar(255) Null,
Surcharge_Description varchar(MAX) Null,
Base_Claim_Reserve float Null,
Surcharge_Reserve float Null,
Dealer_Remittance float Null,
Admin_Fees float Null,
Commissions float Null,
Claim_Reserve_Earned float Null,
Cancel_Calculation_Date datetime Null,
Refund_Date datetime Null,
Refund_Reserve_Amount float Null,
Refund_Odometer_Mileage varchar(255) Null,
sIssue_State varchar(255) Null,
Admin_5 float null,
Admin_7 float null
)
insert into GSFSContract_Detail(
Contract_Id,
Status_Id,
Insurance_Carrier,
Contract_Sale_Date,
Production_Source,
New_Used,
Vehicle_Band,
Rate_Book,
Plan_Code,
Plan_Deductible,
Contract_Number,
Dealer_Number,
Effective_Date,
Expiration_Date,
Contract_Term,
Expiration_Time_Terms,
Sale_Odometer,
Expiration_Odometer,
Expiration_Time_mileage,
Make,
Model,
Model_Year,
Vehicle_Class,
Surcharge_Description,
Base_Claim_Reserve,
Surcharge_Reserve,
Dealer_Remittance,
Admin_Fees,
Commissions,
Claim_Reserve_Earned,
Cancel_Calculation_Date,
Refund_Date,
Refund_Reserve_Amount,
Refund_Odometer_Mileage,
sIssue_State,
Admin_5,
Admin_7

)

Select
ltrim(rtrim([Field1])) as Contract_Id,
ltrim(rtrim([Field2])) as Status_Id,
ltrim(rtrim([Insurance_Carrier])) as Insurance_Carrier,
Cast([Field4] as date) as Contract_Sale_Date,
ltrim(rtrim([Field5])) as Production_Source,
Left(ltrim(rtrim([Field6])), 1) as New_Used,
Left(ltrim(rtrim([Field7])), 1)as Vehicle_Band,
ltrim(rtrim([Field8])) as Rate_Book,
ltrim(rtrim([Field9])) as Plan_Code,
ltrim(rtrim([Field10])) as Plan_Deductible,
ltrim(rtrim([Field11])) as Contract_Number,
dealernums.Dealer_No as Dealer_Number,
Cast([Field12] as date) as Effective_Date,
CAst([Field13] as date) as Expiration_Date,
[Field14] as Contract_Term,
[Field15] as Expiration_Time_Terms,
[Field16] as Sale_Odometer,
[Field17] as Expiration_Odometer,
[Field18] as Expiration_Time_mileage,
ltrim(rtrim([Field19])) as Make,
ltrim(rtrim([Field21])) as Model,
ltrim(rtrim([Field22])) as Model_Year,
ltrim(rtrim([Field23])) as Vehicle_Class,
'' as Surcharge_Description,
[Field24] as Base_Claim_Reserve,
[Field25] as Surcharge_Reserve,
[Field26] as Dealer_Remittance,
[Field27] as Admin_Fees,
[Field28] as Commissions,
[Field29] as Claim_Reserve_Earned,
CASE WHEN Field30 = '' THEN NULL ELSE CAST([Field30] as Date) END as Cancel_Calculation_Date,
Null as Refund_Date,
Cast([Field31] as float) * (-1.00) as Refund_Reserve_Amount,
ltrim(rtrim([Field32])) as Refund_Odometer_Mileage,
[Field33] as sIssue_State,
[Field34] as Admin_5,
[Field35] as Admin_7
from RawData_Contracts 
left join TBL_Insurance_Carrier on
[Field3] = Insurance_Carrier_Num
left join (	select Contract_No, Dealer_No
			from Reinsurance_Dec_2022_ITD_By_Contract
			group by Contract_No, Dealer_No) dealernums on ltrim(rtrim(dealernums.Contract_No)) = ltrim(rtrim([Field11]))


--IR 12/31/18 - Client provided data for extra insurance carriers. Filtering them out here as they are being excluded from the analysis
DELETE 
from GSFSContract_Detail
where Insurance_Carrier in ('ORPP',
'GSOX',
'MTLS',
'RSSE',
'TACX',
'GAT',
'AIG',
'SNL',
'MDL',
'SNT',
'GIPA',
'GATA',
--'DTWH', --added back in 12/31/2021, XS carrier, included in Reserve for GPW file
'MGA',
'SPM',
'FLNW',
'TAC',
'GIP',
'ORPB',
'TPLS',
--'APP', --added 12/31/19 - 0 claims - 42 contracts 
'FLOW', --added 12/31/19 - 10 claims - 28 contracts
--'TLC', --added 12/31/19 - 0 claims - 337 contracts) --added back in 12/31/2021, XS carrier, included in Reserve for GPW file
--'LTWS' --added 12/31/20 --added back in 12/31/2021, XS carrier, included in Reserve for GPW file
--'WHBD', --added 12/31/20
--'DWBD', --added 12/31/20
--'ANBD', --added 12/31/20
--'ANBU', --added 12/31/20
--'DWBU', --added 12/31/20
--'APPU', --added 12/31/20
--'DWAU' --added 12/31/20
--,'CCAP' --Added 12/31/21 --added back in 12/31/2021, XS carrier, included in Reserve for GPW file
--,'CCFD'--Added 12/31/21 --added back in 12/31/2021, 1$ carrier, included in Reserve for GPW file
--,'DWAP'--Added 12/31/21
'DWDC'--Added 12/31/21
--,'DWFG'--Added 12/31/21 --added back in 12/31/2021, XS carrier, included in Reserve for GPW file
,'JDAO'--Added 12/31/21
,'JDDC'--Added 12/31/21
,'JWDC'--Added 12/31/21
,'JWVP'--Added 12/31/21
,'OTMM'--Added 12/31/21
--,'WHAU'--Added 12/31/21
--,'WHDC'--Added 12/31/21 --added back in 12/31/2021, XS carrier, included in Reserve for GPW file
,'GWAN' --Added 12/31/21 These have historically been filtered out at the sentruity insured = 1 level
,'RSLA' --Added 12/31/22 1 contract. not in premium mapping workbook
) 

--Check for new carriers
--SELECT GSFSContract_Detail.Insurance_Carrier, count(*)
--from GSFSContract_Detail
--left join (select GSFSContract_Detail.Insurance_Carrier from [36143_Sentruity_202012].dbo.GSFSContract_Detail group by GSFSContract_Detail.Insurance_Carrier) old_carrier on old_carrier.Insurance_Carrier = GSFSContract_Detail.Insurance_Carrier
--where old_carrier.Insurance_Carrier is null
--group by GSFSContract_Detail.Insurance_Carrier
GO
