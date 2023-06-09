USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_02_UPDATE_GPWContracts]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_02_UPDATE_GPWContracts] AS

DECLARE @BegDate AS DATE
SET @BegDate = (SELECT BegDate FROM TBL_DBVALUES)
DECLARE @ValDate AS DATE
SET @ValDate = (SELECT ValDate FROM TBL_DBVALUES)

UPDATE GPWContracts
SET GPWContracts.GPWEffectiveQuarter = 
(Case	When Month([GPWEffectiveDate])=1
	Then '1.'+ Cast(Year([GPWEffectiveDate])as varchar) + '.'
	When Month([GPWEffectiveDate])=2
	Then '1.'+ Cast(Year([GPWEffectiveDate])as varchar) + '.'
	When Month([GPWEffectiveDate])=3
	Then '1.'+ Cast(Year([GPWEffectiveDate])as varchar) + '.'
	When Month([GPWEffectiveDate])=4
	Then '2.'+ Cast(Year([GPWEffectiveDate])as varchar) + '.'
	When Month([GPWEffectiveDate])=5
	Then '2.'+ Cast(Year([GPWEffectiveDate])as varchar) + '.'
	When Month([GPWEffectiveDate])=6
	Then '2.'+ Cast(Year([GPWEffectiveDate])as varchar) + '.'
	When Month([GPWEffectiveDate])=7
	Then '3.'+ Cast(Year([GPWEffectiveDate])as varchar) + '.'
	When Month([GPWEffectiveDate])=8
	Then '3.'+ Cast(Year([GPWEffectiveDate])as varchar) + '.'
	When Month([GPWEffectiveDate])=9
	Then '3.'+ Cast(Year([GPWEffectiveDate])as varchar) + '.'
	When Month([GPWEffectiveDate])=10
	Then '4.'+ Cast(Year([GPWEffectiveDate])as varchar) + '.'
	When Month([GPWEffectiveDate])=11
	Then '4.'+ Cast(Year([GPWEffectiveDate])as varchar) + '.'
	When Month([GPWEffectiveDate])=12
	Then '4.'+ Cast(Year([GPWEffectiveDate])as varchar) + '.'
End)

UPDATE GPWContracts
SET
GPWContracts.GPWEffectiveYear = Year([GPWEffectiveDate])

UPDATE GPWContracts
SET GPWContracts.GPWExpireMiles = case when [New_Used]='N' then GPWTermMiles else GPWEffectiveMiles + GPWTermMiles end
--GPWContracts.GPWExpireMiles = Expiration_Time_mileage

UPDATE GPWContracts
SET
GPWContracts.GPWCancelQuarter = 
(Case	When Month([GPWCancelDate])=1
	Then '1.'+ Cast(Year([GPWCancelDate])as varchar) + '.'
	When Month([GPWCancelDate])=2
	Then '1.'+ Cast(Year([GPWCancelDate])as varchar) + '.'
	When Month([GPWCancelDate])=3
	Then '1.'+ Cast(Year([GPWCancelDate])as varchar) + '.'
	When Month([GPWCancelDate])=4
	Then '2.'+ Cast(Year([GPWCancelDate])as varchar) + '.'
	When Month([GPWCancelDate])=5
	Then '2.'+ Cast(Year([GPWCancelDate])as varchar) + '.'
	When Month([GPWCancelDate])=6
	Then '2.'+ Cast(Year([GPWCancelDate])as varchar) + '.'
	When Month([GPWCancelDate])=7
	Then '3.'+ Cast(Year([GPWCancelDate])as varchar) + '.'
	When Month([GPWCancelDate])=8
	Then '3.'+ Cast(Year([GPWCancelDate])as varchar) + '.'
	When Month([GPWCancelDate])=9
	Then '3.'+ Cast(Year([GPWCancelDate])as varchar) + '.'
	When Month([GPWCancelDate])=10
	Then '4.'+ Cast(Year([GPWCancelDate])as varchar) + '.'
	When Month([GPWCancelDate])=11
	Then '4.'+ Cast(Year([GPWCancelDate])as varchar) + '.'
	When Month([GPWCancelDate])=12
	Then '4.'+ Cast(Year([GPWCancelDate])as varchar) + '.'
End)

UPDATE GPWContracts
SET
GPWContracts.GPWFlatCancel = 
(Case	When [GPWCancelDate]<=@ValDate
	Then (Case	When [Base_Claim_Reserve]+[Surcharge_Reserve]-[Refund_Reserve_Amount]<=0
			Then 'F'
	--Then (Case	When [GPWContracts].[Claim_Reserve_Earned]<=0
	--		Then 'F'
	--		When [GPWContracts].[Claim_Reserve_Earned] Is Null
	--		Then 'F'
			Else '' End)
	Else Null
End)

UPDATE GPWContracts
SET GPWContracts.GPWEstimatedAge = DATEDIFF(m,[GPWEffectiveDate],Cast(@ValDate as datetime))


--Tire & Wheel 
UPDATE GPWContracts
SET 
GPWContracts.[GPW N/U/P] = 
(Case 	When [New_Used]='U'
	Then 'U'
	Else (Case 	When ([GPWEffectiveMiles]<12001 or [Insurance_Carrier]='SDC' or [Insurance_Carrier]='SDLA' or [Insurance_Carrier]='EXTI' or [Insurance_Carrier]='DWTW' or [Insurance_Carrier]='JWTW' or [Insurance_Carrier]='JWT2' or [Insurance_Carrier]='EXTN' or [Insurance_Carrier]='EXLA' or [Insurance_Carrier]='DTWH' or Insurance_Carrier in ('TTAW','TFTW','TWNR') )
			Then 'N'
			Else 'P' End)
	End)

--GAP Product Types
UPDATE GPWContracts
SET GPWContracts.[GPW N/U/P] = 'U'
--2014 code
--Where ([New_Used]='N' and [Vehicle_Band]='P') 
Where ([New_Used]='N' and Sale_Odometer > 12000) 
and	([Insurance_Carrier]='MLA' or [Insurance_Carrier]='GWGS' or [Insurance_Carrier]='GWNS' 
		or [Insurance_Carrier]='GWRI' or [Insurance_Carrier]='GWRT' or [Insurance_Carrier]='SNW' or [Insurance_Carrier]='GAPS' or [Insurance_Carrier]='GWAN')

--*************SPLIT CERTIFIED?*********************
GO
