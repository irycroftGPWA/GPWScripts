USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_00_b_MAKE_ClaimsSummed]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_00_b_MAKE_ClaimsSummed] AS

DECLARE @ValDate AS DATE
SET @ValDate = (SELECT ValDate FROM TBL_DBVALUES)


IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'ClaimsSummed')
	DROP TABLE ClaimsSummed
CREATE TABLE [ClaimsSummed] (
[Contract_Id] int NULL,
[Insurance_Carrier] varchar (50) NULL, 
[Contract_Number] varchar (255) NULL,
[Claim_Status] varchar (255) NULL,
[Claim_Number] varchar (255) null,
--[Claim_Detail_Line_Id] int NULL,
[Reported_Date] datetime NULL,
[Date_Loss_Occurred] datetime NULL,
[Odometer_At_Time_of_Loss] int NULL,
--[Claim_Type] varchar (255) NULL,
[Amount_Paid] float NULL,
[Date_Claim_Detail_Paid] datetime NULL)
INSERT INTO ClaimsSummed(
[Contract_Id],
[Insurance_Carrier], 
[Contract_Number] ,
[Claim_Status],
[Claim_Number],
--[Claim_Detail_Line_Id],
[Reported_Date] ,
[Date_Loss_Occurred],
[Odometer_At_Time_of_Loss],
--[Claim_Type],
[Amount_Paid],
[Date_Claim_Detail_Paid])
SELECT     
[Contract_Id] as [Contract_Id],
[Insurance_Carrier] as [Insurance_Carrier], 
[Contract_Number] as [Contract_Number],
[Claim_Status] as [Claim_Status],
[Claim_Number] as [Claim_Number],
--[Claim_Detail_Line_Id] as [Claim_Detail_Line_Id],
min([Reported_Date]) as [Reported_Date],
min([Date_Loss_Occurred]) as [Date_Loss_Occurred],
[Odometer_At_Time_of_Loss] as [Odometer_At_Time_of_Loss],
--[Claim_Type] as [Claim_Type],
Sum([Amount_Paid]) as [Amount_Paid],
min([Date_Claim_Detail_Paid]) as [Date_Claim_Detail_Paid]  --12/31/18: Changed max of paid date to min of paid date for consistency between GPWClaims and new IBNR tables
FROM Claims 
WHERE [Date_Claim_Detail_Paid]<=@ValDate and [Claim_Status]<>'Open'
GROUP BY 
[Contract_Id],
[Insurance_Carrier], 
[Contract_Number] ,
[Claim_Status],
[Claim_Number],
--[Claim_Detail_Line_Id],
[Odometer_At_Time_of_Loss]
--[Claim_Type],
--[Date_Claim_Detail_Paid]



IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'ClaimsSummedwOpen')
	DROP TABLE ClaimsSummedwOpen
CREATE TABLE [ClaimsSummedwOpen] (
[Contract_Id] int NULL,
[Insurance_Carrier] varchar (50) NULL, 
[Contract_Number] varchar (255) NULL,
[Claim_Status] varchar (255) NULL,
[Claim_Number] varchar (255) null,
--[Claim_Detail_Line_Id] int NULL,
[Reported_Date] datetime NULL,
[Date_Loss_Occurred] datetime NULL,
--[Odometer_At_Time_of_Loss] int NULL,
--[Claim_Type] varchar (255) NULL,
[Amount_Paid] float NULL,
[Date_Claim_Detail_Paid] datetime NULL)
INSERT INTO ClaimsSummedwOpen(
[Contract_Id],
[Insurance_Carrier], 
[Contract_Number] ,
[Claim_Status],
[Claim_Number],
--[Claim_Detail_Line_Id],
[Reported_Date] ,
[Date_Loss_Occurred],
--[Odometer_At_Time_of_Loss],
--[Claim_Type],
[Amount_Paid],
[Date_Claim_Detail_Paid])
SELECT     
[Contract_Id] as [Contract_Id],
[Insurance_Carrier] as [Insurance_Carrier], 
[Contract_Number] as [Contract_Number],
max([Claim_Status]) as [Claim_Status],
[Claim_Number] as [Claim_Number],
--[Claim_Detail_Line_Id] as [Claim_Detail_Line_Id],
min([Reported_Date]) as [Reported_Date],
min([Date_Loss_Occurred]) as [Date_Loss_Occurred],
--[Odometer_At_Time_of_Loss] as [Odometer_At_Time_of_Loss],
--[Claim_Type] as [Claim_Type],
Sum([Amount_Paid]) as [Amount_Paid],
min([Date_Claim_Detail_Paid]) as [Date_Claim_Detail_Paid]  --12/31/18: Changed max of paid date to min of paid date for consistency between GPWClaims and new IBNR tables
FROM Claims 
GROUP BY 
[Contract_Id],
[Insurance_Carrier], 
[Contract_Number] ,
[Claim_Number]
--[Claim_Detail_Line_Id],
--[Odometer_At_Time_of_Loss]
--[Claim_Type],
--[Date_Claim_Detail_Paid]

/*
IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GAP_Claim_Descriptions_Summed')
	DROP TABLE GAP_Claim_Descriptions_Summed

CREATE TABLE [GAP_Claim_Descriptions_Summed] (
	[Carrier Abr] nvarchar (255) NULL,
	[Claim No] nvarchar (255) NULL,
	[Contract ID] nvarchar (255) NULL,
	[Claim Status] nvarchar (255) NULL,
	[Loss Cause Desc] nvarchar (255) NULL,
	[Contract No] nvarchar (255) NULL,
	[Incurred Claims Amt] float NULL,
	[Paid Claims Amt] float NULL,
	[Paid Claims Total Amt] float NULL
)
INSERT INTO GAP_Claim_Descriptions_Summed(
	[Carrier Abr] ,
	[Claim No] ,
	[Contract ID] ,
	[Claim Status] ,
	[Loss Cause Desc] ,
	[Contract No] ,
	[Incurred Claims Amt] ,
	[Paid Claims Amt] ,
	[Paid Claims Total Amt] 
)
SELECT     
	ltrim(rtrim([Carrier Abr])) ,
	ltrim(rtrim([Claim No])) ,
	ltrim(rtrim([Contract ID])) ,
	max(ltrim(rtrim([Claim Status]))) ,
	ltrim(rtrim([Loss Cause Desc])) ,
	max(ltrim(rtrim([Contract No]))) ,
	sum([Incurred Claims Amt]) ,
	sum([Paid Claims Amt]) ,
	sum([Paid Claims Total Amt]) 
FROM [GAP Claim Descriptions] 
GROUP BY 
	[Carrier Abr] ,
	[Claim No] ,
	[Contract ID] ,
	[Loss Cause Desc] 
*/


--IF EXISTS (SELECT name FROM sysobjects
--	WHERE name = 'GAP_Claim_Descriptions_Summed_01_2018')
--	DROP TABLE GAP_Claim_Descriptions_Summed_01_2018

--CREATE TABLE [GAP_Claim_Descriptions_Summed_01_2018] (
--	[Carrier Abr] nvarchar (255) NULL,
--	[Claim No] nvarchar (255) NULL,
--	[Contract ID] nvarchar (255) NULL,
--	[Claim Status] nvarchar (255) NULL,
--	[Loss Cause Desc] nvarchar (255) NULL,
--	[Contract No] nvarchar (255) NULL,
--	[Claim Paid Year Month] nvarchar (255) NULL,
--	[Claim Entered Year Month] nvarchar (255) NULL,
--	[Sale Year Month] nvarchar (255) NULL,
--	[Loss Occurred Date] datetime NULL,
--	[Incurred Claims Amt] float NULL,
--	[Paid Claims Amt] float NULL,
--	[Paid Claims Total Amt] float NULL
--)
--INSERT INTO GAP_Claim_Descriptions_Summed_01_2018(
--	[Carrier Abr] ,
--	[Claim No] ,
--	[Contract ID] ,
--	[Claim Status] ,
--	[Loss Cause Desc] ,
--	[Contract No] ,
--    [Claim Paid Year Month] ,
--    [Claim Entered Year Month] ,
--    [Sale Year Month] ,
--    [Loss Occurred Date] ,
--	[Incurred Claims Amt] ,
--	[Paid Claims Amt] ,
--	[Paid Claims Total Amt] 
--)
--SELECT     
--	ltrim(rtrim([Carrier Abr])) ,
--	ltrim(rtrim([Claim No])) ,
--	ltrim(rtrim([Contract ID])) ,
--	max(ltrim(rtrim([Claim Status]))) ,
--	ltrim(rtrim([Loss Cause Desc])) ,
--	max(ltrim(rtrim([Contract No]))) ,
--    min(ltrim(rtrim([Claim Paid Year Month]))) , --12/31/18: Changed max of paid date to min of paid date for consistency between GPWClaims and new IBNR tables
--    ltrim(rtrim([Claim Entered Year Month])) , 
--    min(ltrim(rtrim([Sale Year Month]))) ,
--    min([Loss Occurred Date]) ,
--	sum([Incurred Claims Amt]) ,
--	sum([Paid Claims Amt]) ,
--	sum([Paid Claims Total Amt]) 
--FROM [GAP Claim Descriptions 01-2018] 
--GROUP BY 
--	[Carrier Abr] ,
--	[Claim No] ,
--	[Contract ID] ,
--	[Loss Cause Desc] ,
--    [Claim Entered Year Month] 



	IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GAP_Claim_Descriptions_Summed_12_2022')
	DROP TABLE GAP_Claim_Descriptions_Summed_12_2022

CREATE TABLE [GAP_Claim_Descriptions_Summed_12_2022] (
	[Carrier Abr] nvarchar (255) NULL,
	[Claim No] nvarchar (255) NULL,
	[Contract ID] nvarchar (255) NULL,
	[Claim Status] nvarchar (255) NULL,
	[Loss Cause Desc] nvarchar (255) NULL,
	[Contract No] nvarchar (255) NULL,
	[Claim Paid Year Month] nvarchar (255) NULL,
	[Claim Entered Year Month] nvarchar (255) NULL,
	[Sale Year Month] nvarchar (255) NULL,
	[Loss Occurred Date] datetime NULL,
	[Incurred Claims Amt] float NULL,
	[Paid Claims Amt] float NULL,
	[Paid Claims Total Amt] float NULL
)
INSERT INTO GAP_Claim_Descriptions_Summed_12_2022(
	[Carrier Abr] ,
	[Claim No] ,
	[Contract ID] ,
	[Claim Status] ,
	[Loss Cause Desc] ,
	[Contract No] ,
    [Claim Paid Year Month] ,
    [Claim Entered Year Month] ,
    [Sale Year Month] ,
    [Loss Occurred Date] ,
	[Incurred Claims Amt] ,
	[Paid Claims Amt] ,
	[Paid Claims Total Amt] 
)
SELECT     
	ltrim(rtrim([Carrier Abr])) ,
	ltrim(rtrim([Claim No])) ,
	ltrim(rtrim([Contract ID])) ,
	max(ltrim(rtrim([Claim Status]))) ,
	ltrim(rtrim([Loss Cause Desc])) ,
	max(ltrim(rtrim([Contract No]))) ,
    min(ltrim(rtrim([Claim Paid Year Month]))) , --12/31/18: Changed max of paid date to min of paid date for consistency between GPWClaims and new IBNR tables
    ltrim(rtrim([Claim Entered Year Month])) , 
    min(ltrim(rtrim([Sale Year Month]))) ,
    min([Loss Occurred Date]) ,
	sum([Incurred Claims Amt]) ,
	sum([Paid Claims Amt]) ,
	sum([Paid Claims Total Amt]) 
FROM [GAP Claim Descriptions 12-2022] 
GROUP BY 
	[Carrier Abr] ,
	[Claim No] ,
	[Contract ID] ,
	[Loss Cause Desc] ,
    [Claim Entered Year Month] 

GO
