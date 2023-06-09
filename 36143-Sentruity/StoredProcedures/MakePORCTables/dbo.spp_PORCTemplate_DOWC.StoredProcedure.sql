USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[spp_PORCTemplate_DOWC]    Script Date: 5/16/2023 9:50:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spp_PORCTemplate_DOWC] as 


DECLARE @BegDate as DATE
DECLARE @ValDate as DATE
SET @BegDate = (SELECT BegDate FROM Tbl_DBValues)
SET @ValDate = (SELECT ValDate FROM Tbl_DBValues)


----------- Create PORC Claims Table---------------------
IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'PORC_Claims_Sentruity_DOWC')
	DROP TABLE PORC_Claims_Sentruity_DOWC

SELECT
ObligorReinsCodes.DealerGroup as ContractNo,
gpwclaims.Contract_Id as CID,
ObligorReinsCodes.ReinsGroup as RICCode,--RICNum as RICCode,
'Ceded' as PORCSplit,
Case when ObligorReinsCodes.[Carrier Code] = 'DOWC' or [Carrier Code] = 'DLRO' or ObligorReinsCodes.[Carrier Code] = 'DWFG' Then 'Auto'								
	when ObligorReinsCodes.[Carrier Code] = 'DWPM' Then 'PPM'							
	when ObligorReinsCodes.[Carrier Code] = 'DWTW' then 'TW' 
	when ObligorReinsCodes.[Carrier Code] in ('DWAP','DWAU','DWBD','DWBU') then 'ANCL' End as GPWTriangle,
GPWClaims.[GPW N/U/P] as GPWSegment,
GPWClaims.GPWTermMonths,
GPWClaims.GPWEffectiveYear,
GPWClaims.GPWEffectiveQuarter,
Sum(GPWClaims.GPWClaimCount) as GPWClaimCount,
Sum(GPWClaims.GPWClaims) as GPWClaims,
Sum(Case when GPWClaimDate> DATEADD(M, -9, @ValDate)  and GPWClaimDate<= DATEADD(M, -6, @ValDate)  then GPWClaims.GPWClaims else 0 end) as LastQtrClaims3, 
Sum(Case when GPWClaimDate> DATEADD(M, -6, @ValDate)  and GPWClaimDate<= DATEADD(M, -3, @ValDate)  then GPWClaims.GPWClaims else 0 end) as LastQtrClaims2,
Sum(Case when GPWClaimDate> DATEADD(M, -3, @ValDate)  and GPWClaimDate<= @ValDate then GPWClaims.GPWClaims else 0 end) as LastQtrClaims1 
Into PORC_Claims_Sentruity_DOWC
FROM GPWContracts INNER JOIN ObligorReinsCodes ON 																						
GPWContracts.GPWDealer = ObligorReinsCodes.[DO - AO Dealer Number]  and																						
GPWContracts.Insurance_Carrier = ObligorReinsCodes.[Carrier Code]																						
RIGHT OUTER JOIN GPWClaims ON 																						
GPWContracts.Contract_Id = GPWClaims.Contract_Id																						
WHERE     																						
		(GPWContracts.GPWCoverage in ('DOWC_Ex','DWPM_Ex','DWTW_Ex','DWAP_ANCL_Ex','DWAU_ANCL_Ex','DWBD_ANCL_Ex','DWBU_ANCL_Ex','DWFG_Ex') or (GPWContracts.GPWCoverage ='DLRO_Ex' and GPWContracts.GPWDealer in ('MS108D','MS113D','TN114D','TN113D','TX674','TN115D'))) AND 																				
		(GPWContracts.GPWSentruityInsured = 1) AND																				
		(GPWContracts.GPWDealer <> '') AND 																				
		(ObligorReinsCodes.[Carrier Code] in ('DOWC','DWPM','DWTW','DWAP','DWAU','DWBD','DWBU','DWFG') or (ObligorReinsCodes.[Carrier Code] = 'DLRO' and GPWContracts.GPWDealer in ('MS108D','MS113D','TN114D','TN113D','TX674','TN115D')))																					
		and GPWContracts.GPWEffectiveDate BETWEEN @BegDate and @ValDate
GROUP BY 
ObligorReinsCodes.DealerGroup,
gpwclaims.Contract_Id,
ObligorReinsCodes.ReinsGroup,
Case when ObligorReinsCodes.[Carrier Code] = 'DOWC' or [Carrier Code] = 'DLRO' or ObligorReinsCodes.[Carrier Code] = 'DWFG' Then 'Auto'								
	when ObligorReinsCodes.[Carrier Code] = 'DWPM' Then 'PPM'							
	when ObligorReinsCodes.[Carrier Code] = 'DWTW' then 'TW' 
	when ObligorReinsCodes.[Carrier Code] in ('DWAP','DWAU','DWBD','DWBU') then 'ANCL' End,
GPWClaims.[GPW N/U/P],
GPWClaims.GPWTermMonths,
GPWClaims.GPWEffectiveYear,
GPWClaims.GPWEffectiveQuarter
ORDER BY 
ObligorReinsCodes.DealerGroup,
gpwclaims.Contract_Id,
ObligorReinsCodes.ReinsGroup,
GPWTriangle,
GPWClaims.[GPW N/U/P],
GPWClaims.GPWTermMonths,
GPWClaims.GPWEffectiveYear,
GPWClaims.GPWEffectiveQuarter


----------- Create PORC Output Prelim Table---------------------
IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'PORC_Output_Sentruity_DOWC_Prelim')
	DROP TABLE PORC_Output_Sentruity_DOWC_Prelim

SELECT
ObligorReinsCodes.DealerGroup as [ContractNo],
GPWContracts.Contract_Id as CID,
Cast(NULL as varchar(255)) as CAT1,
Cast(NULL as varchar(255)) as CAT2,
Cast(NULL as varchar(255)) as CAT3,
'Ceded' as PORCSplit,
ObligorReinsCodes.ReinsGroup as RICCode,-- RICNum as RICCode,
Case when ObligorReinsCodes.[Carrier Code] = 'DOWC' or [Carrier Code] = 'DLRO' or ObligorReinsCodes.[Carrier Code] = 'DWFG' Then 'Auto'								
	when ObligorReinsCodes.[Carrier Code] = 'DWPM' Then 'PPM'							
	when ObligorReinsCodes.[Carrier Code] = 'DWTW' then 'TW' 
	when ObligorReinsCodes.[Carrier Code] in ('DWAP','DWAU','DWBD','DWBU') then 'ANCL' End as GPWTriangle,
[GPW N/U/P] as GPWSegment,
GPWTermMonths,
GPWEffectiveYear,
GPWEffectiveQuarter,
Sum(GPWContractCount) as GPWContractCnt,
Sum((GPWContractCount - GPWCancelCount)) as GPWActiveCnt,
Sum(GPWCancelCount) as GPWCancelCnt,
Sum(GPWActiveReserve) as GPWActiveReserve,
Sum(GPWCancelReserve) as GPWCancelReserve,
Sum(GPWCancelReserve + GPWActiveReserve) as GPWNetReserve,
Cast(NULL as float) as AvgActiveRx,
Cast(0 as float) as GPWClaimCount,
Cast(0 as float) as GPWClaims,
Cast(0 as float) as LastQtrClaims3,
Cast(0 as float) as LastQtrClaims2,
Cast(0 as float) as LastQtrClaims1,
Sum(GPWSentruityGrossPrem) as GrossRx
INTO PORC_Output_Sentruity_DOWC_Prelim
FROM GPWContracts INNER JOIN ObligorReinsCodes ON 																	
GPWContracts.GPWDealer = ObligorReinsCodes.[DO - AO Dealer Number] and 																	
GPWContracts.Insurance_Carrier = ObligorReinsCodes.[Carrier Code]																	
WHERE	(GPWContracts.GPWCoverage in ('DOWC_Ex','DWPM_Ex','DWTW_Ex','DWAP_ANCL_Ex','DWAU_ANCL_Ex','DWBD_ANCL_Ex','DWBU_ANCL_Ex','DWFG_Ex') or (GPWContracts.GPWCoverage ='DLRO_Ex' and GPWContracts.GPWDealer in ('MS108D','MS113D','TN114D','TN113D','TX674','TN115D'))) AND 																
		(GPWContracts.GPWSentruityInsured = 1) AND															
		(GPWContracts.GPWDealer <> '') AND 															
		(ObligorReinsCodes.[Carrier Code] in ('DOWC','DWPM','DWTW','DWAP','DWAU','DWBD','DWBU','DWFG') or (ObligorReinsCodes.[Carrier Code] = 'DLRO' and GPWContracts.GPWDealer in ('MS108D','MS113D','TN114D','TN113D','TX674','TN115D')))																																													
		and GPWContracts.GPWEffectiveDate BETWEEN @BegDate and @ValDate
GROUP BY 
ObligorReinsCodes.DealerGroup,
GPWContracts.Contract_Id,
ObligorReinsCodes.ReinsGroup,
Case when ObligorReinsCodes.[Carrier Code] = 'DOWC' or [Carrier Code] = 'DLRO' or ObligorReinsCodes.[Carrier Code] = 'DWFG' Then 'Auto'								
	when ObligorReinsCodes.[Carrier Code] = 'DWPM' Then 'PPM'							
	when ObligorReinsCodes.[Carrier Code] = 'DWTW' then 'TW' 
	when ObligorReinsCodes.[Carrier Code] in ('DWAP','DWAU','DWBD','DWBU') then 'ANCL' End,
[GPW N/U/P],
GPWTermMonths,
GPWEffectiveYear,
GPWEffectiveQuarter
ORDER BY 
ObligorReinsCodes.DealerGroup,
GPWContracts.Contract_Id,
ObligorReinsCodes.ReinsGroup,
GPWTriangle,
[GPW N/U/P],
GPWTermMonths,
GPWEffectiveYear,
GPWEffectiveQuarter

----------- Joins Claims and Output Table
Update PORC_Output_Sentruity_DOWC_Prelim SET 
GPWClaimCount = PORC_Claims.GPWClaimCount,
GPWClaims = PORC_Claims.GPWClaims,
LastQtrClaims3 = PORC_Claims.LastQtrClaims3,
LastQtrClaims2 = PORC_Claims.LastQtrClaims2,
LastQtrClaims1 = PORC_Claims.LastQtrClaims1
FROM PORC_Output_Sentruity_DOWC_Prelim as PORC_Output INNER JOIN PORC_Claims_Sentruity_DOWC as PORC_Claims ON 
PORC_Output.ContractNo = PORC_Claims.ContractNo AND 
PORC_Output.CID = PORC_Claims.CID AND 
PORC_Output.PORCSplit = PORC_Claims.PORCSplit AND 
PORC_Output.GPWTriangle = PORC_Claims.GPWTriangle AND 
PORC_Output.GPWSegment = PORC_Claims.GPWSegment AND 
PORC_Output.GPWTermMonths = PORC_Claims.GPWTermMonths AND 
PORC_Output.GPWEffectiveYear = PORC_Claims.GPWEffectiveYear AND 
PORC_Output.RICCode = PORC_Claims.RICCode AND 
PORC_Output.GPWEffectiveQuarter = PORC_Claims.GPWEffectiveQuarter

Update PORC_Output_Sentruity_DOWC_Prelim SET 
CAT1 = PORCSplit + ' ' + RICCode + ' ' + GPWTriangle,
CAT2 = PORCSplit + ' ' + RICCode + ' ' + GPWTriangle + ' ' + GPWSegment,
CAT3 = PORCSplit + ' ' + RICCode + ' ' + GPWTriangle + ' ' + GPWSegment + ' ' + Cast(GPWTermMonths as varchar) + ' ' + GPWEffectiveQuarter


IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'PORC_Output_Sentruity_DOWC')
	DROP TABLE PORC_Output_Sentruity_DOWC

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
Into PORC_Output_Sentruity_DOWC
From PORC_Output_Sentruity_DOWC_Prelim
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

Update PORC_Output_Sentruity_DOWC SET
AvgActiveRx = Case when GPWActiveCnt<=0 then 0 else GPWActiveReserve/GPWActiveCnt end

--To Excel
Select *
From PORC_Output_Sentruity_DOWC
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
