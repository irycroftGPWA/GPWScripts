USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_00_a_MAKE_Claims]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_00_a_MAKE_Claims] AS
IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'Claims')
	DROP TABLE Claims
CREATE TABLE [Claims] (
[Contract_Id] varchar(255) NULL, 
[Insurance_Carrier] varchar (255) NULL, 
[Contract_Number] varchar (255) NULL, 
[Claim_Status] varchar (255) NULL, 
[Claim_Number] varchar (255) NULL, 
[Claim_Detail_Line_Id] int NULL, 
[Reported_Date] datetime NULL, 
[Date_Loss_Occurred] datetime NULL, 
[Odometer_At_Time_of_Loss] int NULL, 
[Claim_Type] varchar (255) NULL, 
[Amount_Paid] float NULL, 
[Date_Claim_Detail_Paid] datetime NULL )
INSERT INTO Claims(
[Contract_Id],
[Insurance_Carrier], 
[Contract_Number] ,
[Claim_Status],
[Claim_Number],
[Claim_Detail_Line_Id],
[Reported_Date] ,
[Date_Loss_Occurred],
[Odometer_At_Time_of_Loss],
[Claim_Type],
[Amount_Paid],
[Date_Claim_Detail_Paid])
SELECT     
ltrim(rtrim([Column 0])) as [Contract_Id],
Ltrim(Rtrim([Column 1])) as [Insurance_Carrier], 
ltrim(rtrim([Column 2])) as [Contract_Number] ,
ltrim(rtrim([Column 3])) as [Claim_Status],
ltrim(rtrim([Column 4])) as [Claim_Number],
[Column 5] as [Claim_Detail_Line_Id],
cast(left([Column 6],4) + '/' + RIGHT(left([Column 6],6),2) + '/' + right([Column 6],2)  as date) as [Reported_Date] ,
Case when [Column 7] = '' or [Column 7] is null then '1/1/1900' else cast(left([Column 7],4) + '/' + RIGHT(left([Column 7],6),2) + '/' + right([Column 7],2)  as date ) end as [Date_Loss_Occurred],
[Column 8] as [Odometer_At_Time_of_Loss],
ltrim(rtrim([Column 9])) as [Claim_Type],
[Column 10] as [Amount_Paid],
Case when [Column 11] = '' or [Column 11]  is null then '1/1/1900' else cast(left([Column 11],4) + '/' + RIGHT(left([Column 11],6),2) + '/' + right([Column 11],2)  as date ) end as [Date_Claim_Detail_Paid]
FROM RawData_Claims



--IR 12/31/18 - Client provided contracts and claims for extra insurance carriers that are being excluded from the analysis

delete 
from Claims
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
--'DTWH', --added back 12/31/21, XS carrier, included in reserve for GPW file
'MGA',
'SPM',
'FLNW',
'TAC',
'GIP',
'ORPB',
'TPLS',
--'APP', --added 12/31/19 - 0 claims - 42 contracts  --Added Ancillary for 12/31/21 analysis so uncommented
'FLOW', --added 12/31/19 - 10 claims - 28 contracts
--'TLC', --added 12/31/19 - 0 claims - 337 contracts) --added back 12/31/21, XS carrier, included in reserve for GPW file
--'LTWS', --added 12/31/20 --added back 12/31/21, XS carrier, included in reserve for GPW file
'WHBH', --added 12/31/20
--'DWBD', --added 12/31/20 --Added Ancillary for 12/31/21 analysis so uncommented
--'ANBU', --added 12/31/20 --Added Ancillary for 12/31/21 analysis so uncommented
--'DWBU', --added 12/31/20 --Added Ancillary for 12/31/21 analysis so uncommented
--'APPU', --added 12/31/20 --Added Ancillary for 12/31/21 analysis so uncommented
--'DWAU', --added 12/31/20 --Added Ancillary for 12/31/21 analysis so uncommented
--'ANBD', --Added 12/31/21 --Added Ancillary for 12/31/21 analysis so uncommented
--'WHBD' --Added 12/31/21 --Added Ancillary for 12/31/21 analysis so uncommented
--'CCAP' --added 12/31/21 --added back 12/31/21, XS carrier, included in reserve for GPW file
--,'CCFD' --added 12/31/21 --added back 12/31/21, 1$ carrier, included in reserve for GPW file
'DWDC' --added 12/31/21
--,'DWFG' --added 12/31/21--added back 12/31/21, XS carrier, included in reserve for GPW file
,'JDAO' --added 12/31/21
,'JDDC' --added 12/31/21
,'JWDC' --added 12/31/21
--,'WHDC' --added 12/31/21 --added back 12/31/21, XS carrier, included in reserve for GPW file
,'GWAN' --added 12/31/21 These have historically been filtered out at the Sentruity Insured = 1 phase
,'RSLA' --added 12/31/22 not in the premium mappings workbook
) 

--IR 12/31/18 - New insurance carriers excluded from the analysis specific to Claims
--IR 12/31/2019 - new insurance carrier 'FLOW' added

delete
from Claims
where Insurance_Carrier in ('CUVX','GAP','MBS','MBX', 'TGGX')

GO
