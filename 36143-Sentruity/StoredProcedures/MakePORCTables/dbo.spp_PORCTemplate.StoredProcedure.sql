USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[spp_PORCTemplate]    Script Date: 5/16/2023 9:50:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spp_PORCTemplate] as 

DECLARE @BegDate as DATE
DECLARE @ValDate as DATE
SET @BegDate = (SELECT BegDate FROM Tbl_DBValues)
SET @ValDate = (SELECT ValDate FROM Tbl_DBValues)

----------- Create PORC Claims Table---------------------
IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'PORC_Claims_Sentruity')
	DROP TABLE PORC_Claims_Sentruity

;with RetroCFC as (
select GPWContracts.Contract_Id, sum(Ceding_Percentage) CedingPercentage
from GPWContracts
left join SentruityContractSplit2022 on GPWContracts.Contract_Id = SentruityContractSplit2022.Contract_Id
where Reinsurance_Company_Name in ('4 Rocking Girls Reinsurance, Ltd.'
,'Bewrite Reinsurance, Ltd.'
,'Charles Hamilton Wayne Reinsurance Company, Ltd.'
,'NMHMR Reinsurance, Ltd.'
,'Shelby Wayne 2 Reinsurance, Ltd.'
,'SRCT 3 Reinsurance, Ltd.'
,'Triple Re, Limited')
and EOMONTH(Contract_Sale_Date) < '12/31/2022'
group by GPWContracts.Contract_Id)
, TRIPAC_Reinsurers as (
Select 'JDS Schoemaker Service Insurance Corporation, Ltd.' as ReinsurerName, '0054' as RicCode, .15 as Ceding_Percentage
union 
Select 'Schoemaker Service Insurance Corporation, Ltd.' as ReinsurerName, '0097' as RicCode, .85 as Ceding_Percentage
)

SELECT
ReinsurerName as ContractNo,
gpwclaims.Contract_Id as CID,
RicCode as RICCode,--RICNum as RICCode,
'PARC' as PORCSplit,
Tbl_GPWCoveragePORCTriangleMapping.GPWTriangle,
[GPW N/U/P] as GPWSegment,
GPWTermMonths,
GPWEffectiveYear,
GPWEffectiveQuarter,
Sum(GPWClaimCount * COALESCE (cast(split.Ceding_Percentage as float) , 1)) as GPWClaimCount,
Sum(GPWClaims.GPWClaims * COALESCE (cast(split.Ceding_Percentage as float) , 1)) as GPWClaims,
Sum(Case when GPWClaimDate> DATEADD(M, -9, @ValDate)  and GPWClaimDate<= DATEADD(M, -6, @ValDate)  then GPWClaims * COALESCE (cast(split.Ceding_Percentage as float) , 1) else 0 end) as LastQtrClaims3, 
Sum(Case when GPWClaimDate> DATEADD(M, -6, @ValDate)  and GPWClaimDate<= DATEADD(M, -3, @ValDate)  then GPWClaims * COALESCE (cast(split.Ceding_Percentage as float) , 1) else 0 end) as LastQtrClaims2,
Sum(Case when GPWClaimDate> DATEADD(M, -3, @ValDate)  and GPWClaimDate<= @ValDate then GPWClaims * COALESCE (cast(split.Ceding_Percentage as float) , 1) else 0 end) as LastQtrClaims1 
Into PORC_Claims_Sentruity
FROM     dbo.GPWClaims INNER JOIN										
            dbo.SentruityContractSplit2022 split ON dbo.GPWClaims.Contract_Id = split.Contract_Id										
			inner join Tbl_RicCodesForPORCAnalysis on Tbl_RicCodesForPORCAnalysis.ReinsurerName = case when GPWReinsurer = 'Emerald Bay' OR GPWReinsurer = 'Tricor' THEN GPWReinsurer ELSE split.Reinsurance_Company_Name END
			left join Tbl_GPWCoveragePORCTriangleMapping on GPWClaims.GPWCoverage = Tbl_GPWCoveragePORCTriangleMapping.GPWCoverage
LEFT OUTER JOIN dbo.GAP_Claim_Descriptions_Summed_12_2022 ON 
                  dbo.gpwclaims.Claim_Number = dbo.GAP_Claim_Descriptions_Summed_12_2022.[Claim No] AND 
                  dbo.Gpwclaims.Contract_Id = dbo.GAP_Claim_Descriptions_Summed_12_2022.[Contract ID]
left join RetroCFC on RetroCFC.Contract_Id = GPWClaims.Contract_Id
where split.Reinsurance_Type in ('CFC (Earned)','CFC','NCFC-Tricor','NCFC-Emerald Bay')
--Leblanc is retained
and split.Reinsurance_Company_Name  <> 'Greg Leblanc Reinsurance Company, Ltd.'
AND (split.Ceding_Company_Abr = 'Sen') AND (dbo.GPWClaims.GPWSentruityInsured = 1) 
and GPWEffectiveYear >= year(@begdate) 
and GPWEffectiveYear <= year(@valdate)						
and Right(dbo.GPWClaims.GPWCoverage ,3) = '1st' 
AND (GPWTermMonths > 0) AND (GPWTermMonths < 121) 
AND ((GPWFlatCancel IS NULL) or (GPWFlatCancel = '') )
AND GPWRelativeCancelQtr>=0and GPWRelativeClaimQtr>0
AND GPWContractCount > 0
AND (GPWCLAIMS.GPWActiveReserve > 0 OR GPWCancelReserve > 0)
AND [GPWClaimDate] <= @ValDate and [GPWClaimDate] >= @BegDate
AND (GPWClaims > 0) 
and NOT(([GPWClaimDate] > CONVERT(DATETIME, '2017-08-24 00:00:00', 102) AND [GPWClaimDate] < CONVERT(DATETIME, '2017-09-05 00:00:00', 102)) AND ([GAP_Claim_Descriptions_Summed_12_2022].[Loss Cause Desc] = N'GAP Buyout - Flood') and dbo.GAP_Claim_Descriptions_Summed_12_2022.[Loss Cause Desc] is not null)
--Excluding the RetroCFC contracts
and RetroCFC.Contract_Id is null
GROUP BY 
ReinsurerName,
gpwclaims.Contract_Id,
RicCode,
Tbl_GPWCoveragePORCTriangleMapping.GPWTriangle,
[GPW N/U/P],
GPWTermMonths,
GPWEffectiveYear,
GPWEffectiveQuarter

union all 

select ReinsurerName as ContractNo
, Contract_Id as CID
, RicCode as RICCode
, 'PARC' as PORCSplit
, 'TRIPAC' as GPWTriangle
, [GPW N/U/P] as GPWSegment
, GPWTermMonths
, GPWEffectiveYear
, GPWEffectiveQuarter
, sum(GPWClaimCount*Ceding_Percentage) as GPWClaimCount
, sum(GPWClaims*Ceding_Percentage) as GPWClaims
,Sum(Case when GPWClaimDate> DATEADD(M, -9, @ValDate)  and GPWClaimDate<= DATEADD(M, -6, @ValDate)  then GPWClaims * Ceding_Percentage else 0 end) as LastQtrClaims3 
, Sum(Case when GPWClaimDate> DATEADD(M, -6, @ValDate)  and GPWClaimDate<= DATEADD(M, -3, @ValDate)  then GPWClaims * Ceding_Percentage else 0 end) as LastQtrClaims2
, Sum(Case when GPWClaimDate> DATEADD(M, -3, @ValDate)  and GPWClaimDate<= @ValDate then GPWClaims * Ceding_Percentage else 0 end) as LastQtrClaims1 
from GPWClaims, TRIPAC_Reinsurers
where Insurance_Carrier = 'TRIPAC'
and GPWEffectiveYear >= year(@Begdate)
and GPWEffectiveYear <= year(@Valdate)
and GPWReinsurer = 'TRIPAC'
and right(GPWCoverage,3) ='1st'
and GPWTermMonths between 1 and 120
and GPWContractCount > 0
and (GPWActiveReserve > 0 or GPWCancelReserve > 0)
and GPWClaimDate between @Begdate and @Valdate
and GPWClaims > 0
group by 
ReinsurerName,
Contract_Id,
RicCode,
[GPW N/U/P],
GPWTermMonths,
GPWEffectiveYear,
GPWEffectiveQuarter
ORDER BY 
ReinsurerName,
CID,
RicCode,
GPWTriangle,
[GPW N/U/P],
GPWTermMonths,
GPWEffectiveYear,
GPWEffectiveQuarter

----------- Create PORC Output Prelim Table---------------------
IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'PORC_Output_Sentruity_Prelim')
	DROP TABLE PORC_Output_Sentruity_Prelim

;with RetroCFC as (
select GPWContracts.Contract_Id, sum(Ceding_Percentage) CedingPercentage
from GPWContracts
left join SentruityContractSplit2022 on GPWContracts.Contract_Id = SentruityContractSplit2022.Contract_Id
where Reinsurance_Company_Name in ('4 Rocking Girls Reinsurance, Ltd.'
,'Bewrite Reinsurance, Ltd.'
,'Charles Hamilton Wayne Reinsurance Company, Ltd.'
,'NMHMR Reinsurance, Ltd.'
,'Shelby Wayne 2 Reinsurance, Ltd.'
,'SRCT 3 Reinsurance, Ltd.'
,'Triple Re, Limited')
and EOMONTH(Contract_Sale_Date) < '12/31/2022'
group by GPWContracts.Contract_Id)

, TRIPAC_Reinsurers as (
Select 'JDS Schoemaker Service Insurance Corporation, Ltd.' as ReinsurerName, '0054' as RicCode, .15 as Ceding_Percentage
union 
Select 'Schoemaker Service Insurance Corporation, Ltd.' as ReinsurerName, '0097' as RicCode, .85 as Ceding_Percentage
)

SELECT
ReinsurerName as [ContractNo],
GPWContracts.Contract_Id as CID,
Cast(NULL as varchar(255)) as CAT1,
Cast(NULL as varchar(255)) as CAT2,
Cast(NULL as varchar(255)) as CAT3,
'PARC' as PORCSplit,
 RicCode as RICCode,-- RICNum as RICCode,
Tbl_GPWCoveragePORCTriangleMapping.GPWTriangle,
[GPW N/U/P] as GPWSegment,
GPWTermMonths,
GPWEffectiveYear,
GPWEffectiveQuarter,
Sum(GPWContractCount*COALESCE (cast(split.Ceding_Percentage as Float) , 1)) as GPWContractCnt,
Sum((GPWContractCount - GPWCancelCount)*COALESCE (cast(split.Ceding_Percentage as Float) , 1)) as GPWActiveCnt,
Sum(GPWCancelCount*COALESCE (cast(split.Ceding_Percentage as Float) , 1)) as GPWCancelCnt,
Sum(GPWActiveReserve*COALESCE (cast(split.Ceding_Percentage as Float) , 1)) as GPWActiveReserve,
Sum(GPWCancelReserve*COALESCE (cast(split.Ceding_Percentage as Float) , 1)) as GPWCancelReserve,
Sum((GPWCancelReserve + GPWActiveReserve)*COALESCE (cast(split.Ceding_Percentage as Float) , 1)) as GPWNetReserve,
Cast(NULL as float) as AvgActiveRx,
Cast(0 as float) as GPWClaimCount,
Cast(0 as float) as GPWClaims,
Cast(0 as float) as LastQtrClaims3,
Cast(0 as float) as LastQtrClaims2,
Cast(0 as float) as LastQtrClaims1,
Sum(GPWSentruityGrossPrem*COALESCE (cast(split.Ceding_Percentage as Float) , 1)) as GrossRx
INTO PORC_Output_Sentruity_Prelim
FROM     dbo.GPWContracts INNER JOIN														
                  dbo.SentruityContractSplit2022 split ON dbo.GPWContracts.Contract_Id = split.Contract_ID														
						  inner join Tbl_RicCodesForPORCAnalysis on Tbl_RicCodesForPORCAnalysis.ReinsurerName = case when GPWReinsurer = 'Emerald Bay' OR GPWReinsurer = 'Tricor' THEN GPWReinsurer ELSE split.Reinsurance_Company_Name END		
						  left join Tbl_GPWCoveragePORCTriangleMapping on GPWContracts.GPWCoverage = Tbl_GPWCoveragePORCTriangleMapping.GPWCoverage
		left join RetroCFC on RetroCFC.Contract_Id = GPWContracts.Contract_Id
where split.Reinsurance_Type in ('CFC (Earned)','CFC','NCFC-Tricor','NCFC-Emerald Bay')
--Leblanc is retained
and split.Reinsurance_Company_Name  <> 'Greg Leblanc Reinsurance Company, Ltd.'
AND (split.Ceding_Company_Abr = 'Sen') 
AND (dbo.GPWContracts.GPWSentruityInsured = 1) 
AND (dbo.GPWContracts.GPWReinsurer <> 'GS Re Retro') and														
Right(dbo.GPWContracts.GPWCoverage ,3) = '1st' 														
and GPWEffectiveYear <= year(@valdate)														
and GPWEffectiveYear >= year(@begdate)	
--Added 12/2022
and GPWContracts.GPWContractCount > 0
and (GPWContracts.GPWActiveReserve > 0 or GPWContracts.GPWCancelReserve > 0)
--Removing RetroCFC contracts
and RetroCFC.Contract_Id is null
GROUP BY 
ReinsurerName,
GPWContracts.Contract_Id,
RicCode,
Tbl_GPWCoveragePORCTriangleMapping.GPWTriangle,
[GPW N/U/P],
GPWTermMonths,
GPWEffectiveYear,
GPWEffectiveQuarter
--ORDER BY 
--ReinsurerName,
--GPWContracts.Contract_Id,
--RicCode,
--Tbl_GPWCoveragePORCTriangleMapping.GPWTriangle,
--[GPW N/U/P],
--GPWTermMonths,
--GPWEffectiveYear,
--GPWEffectiveQuarter

union all 

select ReinsurerName as [ContractNo]
, Contract_Id as CID
, Cast(NULL as varchar(255)) as CAT1
, Cast(NULL as varchar(255)) as CAT2
, Cast(NULL as varchar(255)) as CAT3
, 'PARC' as PORCSplit
, RicCode as RICCode
, 'TRIPAC' as GPWTriangle
, [GPW N/U/P] as GPWSegment
, GPWTermMonths
, GPWEffectiveYear
, GPWEffectiveQuarter
, Sum(GPWContractCount*Ceding_Percentage) as GPWContractCnt
, Sum((GPWContractCount - GPWCancelCount)*Ceding_Percentage) as GPWActiveCnt
, Sum(GPWCancelCount*Ceding_Percentage) as GPWCancelCnt
, Sum(GPWActiveReserve*Ceding_Percentage) as GPWActiveReserve
, Sum(GPWCancelReserve*Ceding_Percentage) as GPWCancelReserve
, Sum((GPWCancelReserve + GPWActiveReserve)*Ceding_Percentage) as GPWNetReserve
, Cast(NULL as float) as AvgActiveRx
, Cast(0 as float) as GPWClaimCount
, Cast(0 as float) as GPWClaims
, Cast(0 as float) as LastQtrClaims3
, Cast(0 as float) as LastQtrClaims2
, Cast(0 as float) as LastQtrClaims1
, Sum(GPWSentruityGrossPrem*Ceding_Percentage) as GrossRx
from GPWContracts, TRIPAC_Reinsurers
where Insurance_Carrier = 'TRIPAC'
and GPWEffectiveYear >= year(@Begdate)
and GPWEffectiveYear <= year(@Valdate)
and GPWReinsurer = 'TRIPAC'
and right(GPWCoverage,3) ='1st'
and GPWTermMonths between 1 and 120
and GPWContractCount > 0
and (GPWActiveReserve > 0 or GPWCancelReserve > 0)
group by 
ReinsurerName
, Contract_Id
, RicCode
, [GPW N/U/P]
, GPWTermMonths
, GPWEffectiveYear
, GPWEffectiveQuarter
ORDER BY 
ReinsurerName,
CID,
RicCode,
GPWTriangle,
[GPW N/U/P],
GPWTermMonths,
GPWEffectiveYear,
GPWEffectiveQuarter

----------- Joins Claims and Output Table
Update PORC_Output_Sentruity_Prelim SET 
GPWClaimCount = PORC_Claims.GPWClaimCount,
GPWClaims = PORC_Claims.GPWClaims,
LastQtrClaims3 = PORC_Claims.LastQtrClaims3,
LastQtrClaims2 = PORC_Claims.LastQtrClaims2,
LastQtrClaims1 = PORC_Claims.LastQtrClaims1
FROM PORC_Output_Sentruity_Prelim as PORC_Output INNER JOIN PORC_Claims_Sentruity as PORC_Claims ON 
PORC_Output.ContractNo = PORC_Claims.ContractNo AND 
PORC_Output.CID = PORC_Claims.CID AND 
PORC_Output.PORCSplit = PORC_Claims.PORCSplit AND 
PORC_Output.GPWTriangle = PORC_Claims.GPWTriangle AND 
PORC_Output.GPWSegment = PORC_Claims.GPWSegment AND 
PORC_Output.GPWTermMonths = PORC_Claims.GPWTermMonths AND 
PORC_Output.GPWEffectiveYear = PORC_Claims.GPWEffectiveYear AND 
PORC_Output.RICCode = PORC_Claims.RICCode AND 
PORC_Output.GPWEffectiveQuarter = PORC_Claims.GPWEffectiveQuarter

Update PORC_Output_Sentruity_Prelim SET
CAT1 = PORCSplit + ' ' + RICCode + ' ' + GPWTriangle,
CAT2 = PORCSplit + ' ' + RICCode + ' ' + GPWTriangle + ' ' + GPWSegment,
CAT3 = PORCSplit + ' ' + RICCode + ' ' + GPWTriangle + ' ' + GPWSegment + ' ' + Cast(GPWTermMonths as varchar) + ' ' + GPWEffectiveQuarter


IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'PORC_Output_Sentruity')
	DROP TABLE PORC_Output_Sentruity

Select
CAT1,
CAT2,
CAT3,
PORCSplit,
RICCode,
GPWTriangle,
GPWSegment,
GPWTermMonths,
GPWEffectiveYear,
GPWEffectiveQuarter,
Sum(GPWContractCnt) as GPWContractCnt,
Sum(GPWActiveCnt) as GPWActiveCnt,
Sum(GPWCancelCnt) as GPWCancelCnt,
Sum(GPWActiveReserve) as GPWActiveReserve,
Sum(GPWCancelReserve) as GPWCancelReserve,
Sum(GPWNetReserve) as GPWNetReserve,
Cast(NULL as float) as AvgActiveRx,
Sum(GPWClaimCount) as GPWClaimCount,
Sum(GPWClaims) as GPWClaims,
Sum(LastQtrClaims3) as LastQtrClaims3,
Sum(LastQtrClaims2) as LastQtrClaims2,
Sum(LastQtrClaims1) as LastQtrClaims1,
Sum(GrossRx) as GrossRx
Into PORC_Output_Sentruity
From PORC_Output_Sentruity_Prelim
Group by 
CAT1,
CAT2,
CAT3,
PORCSplit,
RICCode,
GPWTriangle,
GPWSegment,
GPWTermMonths,
GPWEffectiveYear,
GPWEffectiveQuarter
Order by 
CAT1,
CAT2,
CAT3,
PORCSplit,
RICCode,
GPWTriangle,
GPWSegment,
GPWTermMonths,
GPWEffectiveYear,
GPWEffectiveQuarter

Update PORC_Output_Sentruity SET
AvgActiveRx = Case when GPWActiveCnt<=0 then 0 else GPWActiveReserve/GPWActiveCnt end

--To Excel
Select *
From PORC_Output_Sentruity
Order by
CAT1,
CAT2,
CAT3,
PORCSplit,
RICCode,
GPWTriangle,
GPWSegment,
GPWTermMonths,
GPWEffectiveYear,
GPWEffectiveQuarter






GO
