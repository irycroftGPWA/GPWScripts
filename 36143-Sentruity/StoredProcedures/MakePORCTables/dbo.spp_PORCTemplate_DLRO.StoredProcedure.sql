USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[spp_PORCTemplate_DLRO]    Script Date: 5/16/2023 9:50:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spp_PORCTemplate_DLRO] as 

----To Excel to create RIC mapping
--Select 
--CustID, 
--Cust_Name,
--Reinsurance_Company, 
--Min(GPWEffectiveDate) as MinEffDt, 
--Max(GPWEffectiveDate) as MaxEffDt, 
--Count(*) as Cnt, 
--Sum(Case when GPWGroup='Reins' then 1 else 0 end) as ReinsCnt,
--Sum(Case when GPWGroup='Direct' then 1 else 0 end) as DirectCnt
--From [36784_Diversified_2020_03].dbo.GPWContracts
--Where Reinsurance_Company<>''
--Group by 
--CustID, 
--Cust_Name,
--Reinsurance_Company
--Order by 
--CustID, 
--Cust_Name,
--Reinsurance_Company

DECLARE @BegDate as DATE
DECLARE @ValDate as DATE
SET @BegDate = (SELECT BegDate FROM Tbl_DBValues)
SET @ValDate = (SELECT ValDate FROM Tbl_DBValues)


----------- Create PORC Claims Table---------------------
IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'PORC_Claims_Sentruity_DLRO')
	DROP TABLE PORC_Claims_Sentruity_DLRO

SELECT
ObligorReinsCodes.DealerGroup as ContractNo,
gpwclaims.Contract_Id as CID,
ObligorReinsCodes.ReinsGroup as RICCode,--RICNum as RICCode,
'Ceded' as PORCSplit,
'DLRO' as GPWTriangle,
GPWClaims.[GPW N/U/P] as GPWSegment,
GPWClaims.GPWTermMonths,
GPWClaims.GPWEffectiveYear,
GPWClaims.GPWEffectiveQuarter,
Sum(GPWClaims.GPWClaimCount) as GPWClaimCount,
Sum(GPWClaims.GPWClaims) as GPWClaims,
Sum(Case when GPWClaimDate> DATEADD(M, -9, @ValDate)  and GPWClaimDate<= DATEADD(M, -6, @ValDate)  then GPWClaims.GPWClaims else 0 end) as LastQtrClaims3, 
Sum(Case when GPWClaimDate> DATEADD(M, -6, @ValDate)  and GPWClaimDate<= DATEADD(M, -3, @ValDate)  then GPWClaims.GPWClaims else 0 end) as LastQtrClaims2,
Sum(Case when GPWClaimDate> DATEADD(M, -3, @ValDate)  and GPWClaimDate<= @ValDate then GPWClaims.GPWClaims else 0 end) as LastQtrClaims1 
Into PORC_Claims_Sentruity_DLRO
FROM GPWContracts INNER JOIN ObligorReinsCodes ON 																	
GPWContracts.GPWDealer = ObligorReinsCodes.[DO - AO Dealer Number]  																	
RIGHT OUTER JOIN GPWClaims ON 																	
GPWContracts.Contract_Id = GPWClaims.Contract_Id and 																	
GPWContracts.Insurance_Carrier = ObligorReinsCodes.[Carrier Code]																	
WHERE     																	
(GPWContracts.GPWCoverage = 'DLRO_Ex')  
AND (GPWContracts.GPWSentruityInsured = 1) 
AND (GPWContracts.GPWDealer <> '') 
AND (ObligorReinsCodes.[Carrier Code] = 'DLRO' or ObligorReinsCodes.[Carrier Code] = 'DOLA')																	
and GPWContracts.GPWEffectiveDate >= @begdate and GPWContracts.GPWEffectiveDate  <= @valdate and ReinsGroup <> 'DOWC002' and ReinsGroup <> 'DOWC022' and ObligorReinsCodes.ReinsGroup <> 'DOWC006'	
GROUP BY 
ObligorReinsCodes.DealerGroup,
gpwclaims.Contract_Id,
ObligorReinsCodes.ReinsGroup,
GPWClaims.[GPW N/U/P],
GPWClaims.GPWTermMonths,
GPWClaims.GPWEffectiveYear,
GPWClaims.GPWEffectiveQuarter
ORDER BY 
ObligorReinsCodes.DealerGroup,
gpwclaims.Contract_Id,
ObligorReinsCodes.ReinsGroup,
GPWClaims.[GPW N/U/P],
GPWClaims.GPWTermMonths,
GPWClaims.GPWEffectiveYear,
GPWClaims.GPWEffectiveQuarter


----------- Create PORC Output Prelim Table---------------------
IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'PORC_Output_Sentruity_DLRO_Prelim')
	DROP TABLE PORC_Output_Sentruity_DLRO_Prelim

SELECT
ObligorReinsCodes.DealerGroup as [ContractNo],
GPWContracts.Contract_Id as CID,
Cast(NULL as varchar(255)) as CAT1,
Cast(NULL as varchar(255)) as CAT2,
Cast(NULL as varchar(255)) as CAT3,
'Ceded' as PORCSplit,
ObligorReinsCodes.ReinsGroup as RICCode,-- RICNum as RICCode,
'DLRO' as GPWTriangle,
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
INTO PORC_Output_Sentruity_DLRO_Prelim
FROM GPWContracts INNER JOIN ObligorReinsCodes ON 																
GPWContracts.GPWDealer = ObligorReinsCodes.[DO - AO Dealer Number] and 																
GPWContracts.Insurance_Carrier = ObligorReinsCodes.[Carrier Code]																
WHERE (GPWContracts.GPWCoverage = 'DLRO_Ex') 
AND (GPWContracts.GPWSentruityInsured = 1) 
AND (GPWContracts.GPWDealer <> '') 
AND (ObligorReinsCodes.[Carrier Code] = 'DLRO' or ObligorReinsCodes.[Carrier Code] = 'DOLA')																
and GPWEffectiveDate >= @begdate and GPWEffectiveDate <=@valdate and ReinsGroup <> 'DOWC002' and ReinsGroup <> 'DOWC022' and ObligorReinsCodes.ReinsGroup <> 'DOWC006'																																
GROUP BY 
ObligorReinsCodes.DealerGroup,
GPWContracts.Contract_Id,
ObligorReinsCodes.ReinsGroup,
[GPW N/U/P],
GPWTermMonths,
GPWEffectiveYear,
GPWEffectiveQuarter
ORDER BY 
ObligorReinsCodes.DealerGroup,
GPWContracts.Contract_Id,
ObligorReinsCodes.ReinsGroup,
[GPW N/U/P],
GPWTermMonths,
GPWEffectiveYear,
GPWEffectiveQuarter

----------- Joins Claims and Output Table
Update PORC_Output_Sentruity_DLRO_Prelim SET 
GPWClaimCount = PORC_Claims.GPWClaimCount,
GPWClaims = PORC_Claims.GPWClaims,
LastQtrClaims3 = PORC_Claims.LastQtrClaims3,
LastQtrClaims2 = PORC_Claims.LastQtrClaims2,
LastQtrClaims1 = PORC_Claims.LastQtrClaims1
FROM PORC_Output_Sentruity_DLRO_Prelim as PORC_Output INNER JOIN PORC_Claims_Sentruity_DLRO as PORC_Claims ON 
PORC_Output.ContractNo = PORC_Claims.ContractNo AND 
PORC_Output.CID = PORC_Claims.CID AND 
PORC_Output.PORCSplit = PORC_Claims.PORCSplit AND 
PORC_Output.GPWTriangle = PORC_Claims.GPWTriangle AND 
PORC_Output.GPWSegment = PORC_Claims.GPWSegment AND 
PORC_Output.GPWTermMonths = PORC_Claims.GPWTermMonths AND 
PORC_Output.GPWEffectiveYear = PORC_Claims.GPWEffectiveYear AND 
PORC_Output.RICCode = PORC_Claims.RICCode AND 
PORC_Output.GPWEffectiveQuarter = PORC_Claims.GPWEffectiveQuarter

Update PORC_Output_Sentruity_DLRO_Prelim SET --BAA Changed to be DLRO--Update PORC_Output_Sentruity_Prelim SET
CAT1 = PORCSplit + ' ' + RICCode + ' ' + GPWTriangle,
CAT2 = PORCSplit + ' ' + RICCode + ' ' + GPWTriangle + ' ' + GPWSegment,
CAT3 = PORCSplit + ' ' + RICCode + ' ' + GPWTriangle + ' ' + GPWSegment + ' ' + Cast(GPWTermMonths as varchar) + ' ' + GPWEffectiveQuarter


IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'PORC_Output_Sentruity_DLRO')
	DROP TABLE PORC_Output_Sentruity_DLRO

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
Into PORC_Output_Sentruity_DLRO
From PORC_Output_Sentruity_DLRO_Prelim
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

Update PORC_Output_Sentruity_DLRO SET---BAA Changed---Update PORC_Output_Sentruity SET
AvgActiveRx = Case when GPWActiveCnt<=0 then 0 else GPWActiveReserve/GPWActiveCnt end

--To Excel
Select *
From PORC_Output_Sentruity_DLRO --BAA Changed----From PORC_Output_Sentruity
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
