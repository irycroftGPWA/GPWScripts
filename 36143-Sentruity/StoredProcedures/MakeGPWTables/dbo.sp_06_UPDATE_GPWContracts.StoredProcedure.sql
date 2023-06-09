USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_06_UPDATE_GPWContracts]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_06_UPDATE_GPWContracts] AS
UPDATE GPWContracts
SET GPWContracts.GPWObligor = 
(Case	When [GPWCoverage]='ADMO_ADMO' or [GPWCoverage]='JWTW_JWTW' or [GPWCoverage]='JWAO_ADMO' or [GPWCoverage]='JWT2_JWTW'
	Then 'ADMO'
	WHEN [GPWCoverage]='DLRO_DLRO' OR [GPWCoverage]='DOLA_DLRO'
	Then 'DLRO'
	WHEN [GPWCoverage]='DOWC_DOWC' OR [GPWCoverage]='DWPM_DWPM' OR [GPWCoverage]='DWTW_DWTW'
	Then 'DOWC'
	When [GPWCoverage]='MLA_MLA' OR [GPWCoverage]='SNW_MLA'
	Then 'GSMBI'
	When [GPWCoverage]='RLA_RLA' or [GPWCoverage]='RLAS_RLA'
	Then 'GSMBI'
	When [GPWCoverage]='RSTR_RSTR' or [GPWCoverage]='MTL_MTL'
	Then 'TRNSAM'
	Else 'GSA'
End)

--IR 2/16/22: Added check on reinsurance type <> Warehouse to all applicable joins on splitlist to make sure we are basing coverage and gpwreinsurer on the reinsured
--portion of the contracts, not the warehoused portion. The warehoused portion is accounted for in makegpwcontractdata and makegpwclaimsdata. They will flow through gpwcontracts as reinsured

UPDATE GPWContracts
SET GPWContracts.GPWCoverage = GPWContracts.GPWCoverage+'_1st'
FROM      dbo.GPWContracts INNER JOIN
                      dbo.SentruityContractSplit2022List ON dbo.GPWContracts.Contract_Number = dbo.SentruityContractSplit2022List.Contract_Number
where SentruityContractSplit2022List.Reinsurance_Type <> 'Warehouse'


UPDATE GPWContracts
SET GPWContracts.GPWCoverage = GPWContracts.GPWCoverage+'_'+GPW_XSvs1st.[1stXS]
FROM         dbo.GPWContracts INNER JOIN
                      dbo.GPW_XSvs1st ON dbo.GPWContracts.Insurance_Carrier = dbo.GPW_XSvs1st.Carrier
WHERE right([GPWCoverage],3)<>'1st' 


UPDATE GPWContracts
SET GPWContracts.GPWAgg_VSC_MBI = GPW_CoverageGroups.GPWAgg_VSC_MBI
FROM         dbo.GPW_CoverageGroups INNER JOIN
                      dbo.GPWContracts ON dbo.GPW_CoverageGroups.GPWCoverage = dbo.GPWContracts.GPWCoverage

UPDATE GPWContracts
SET GPWContracts.GPWAgg_GAP = GPW_CoverageGroups.GPWAgg_GAP
FROM         dbo.GPW_CoverageGroups INNER JOIN
                      dbo.GPWContracts ON dbo.GPW_CoverageGroups.GPWCoverage = dbo.GPWContracts.GPWCoverage

UPDATE GPWContracts
SET GPWContracts.GPWAgg_SNV = GPW_CoverageGroups.GPWAgg_SNV
FROM         dbo.GPW_CoverageGroups INNER JOIN
                      dbo.GPWContracts ON dbo.GPW_CoverageGroups.GPWCoverage = dbo.GPWContracts.GPWCoverage

UPDATE GPWContracts
SET GPWContracts.GPWAgg_CCC = GPW_CoverageGroups.GPWAgg_CCC
FROM         dbo.GPW_CoverageGroups INNER JOIN
                      dbo.GPWContracts ON dbo.GPW_CoverageGroups.GPWCoverage = dbo.GPWContracts.GPWCoverage

UPDATE GPWContracts
SET GPWContracts.GPWAgg_TEC = GPW_CoverageGroups.GPWAgg_TEC
FROM         dbo.GPW_CoverageGroups INNER JOIN
                      dbo.GPWContracts ON dbo.GPW_CoverageGroups.GPWCoverage = dbo.GPWContracts.GPWCoverage

UPDATE GPWContracts
SET GPWContracts.GPWAgg_MTNG = GPW_CoverageGroups.GPWAgg_MTNG
FROM         dbo.GPW_CoverageGroups INNER JOIN
                      dbo.GPWContracts ON dbo.GPW_CoverageGroups.GPWCoverage = dbo.GPWContracts.GPWCoverage

UPDATE GPWContracts
SET GPWContracts.GPWAgg_LTW = GPW_CoverageGroups.GPWAgg_LTW
FROM         dbo.GPW_CoverageGroups INNER JOIN
                      dbo.GPWContracts ON dbo.GPW_CoverageGroups.GPWCoverage = dbo.GPWContracts.GPWCoverage

UPDATE GPWContracts
SET GPWContracts.GPWAgg_SDC = GPW_CoverageGroups.GPWAgg_SDC
FROM         dbo.GPW_CoverageGroups INNER JOIN
                      dbo.GPWContracts ON dbo.GPW_CoverageGroups.GPWCoverage = dbo.GPWContracts.GPWCoverage

update GPWContracts
set GPWContracts.GPWAgg_ANCL = GPW_CoverageGroups.GPWAgg_ANCL
from GPWContracts
inner join GPW_CoverageGroups on GPW_CoverageGroups.GPWCoverage = GPWContracts.GPWCoverage


UPDATE GPWContracts
SET GPWContracts.GPWCoverage=GPW_CoverageGroups.GPWCoverageGroup
FROM         dbo.GPW_CoverageGroups INNER JOIN
                      dbo.GPWContracts ON dbo.GPW_CoverageGroups.GPWCoverage = dbo.GPWContracts.GPWCoverage

--There are some contracts going to RLA_Ex that should be going to RLA_1st
--1/25/22: The carrier changed on some contracts to LTW  but due to this code they are still getting mapped to RLA_Ex. Carrier changed from RLAS to LTW. Added check on carrier
UPDATE GPWContracts
SET GPWContracts.GPWCoverage = GPWContractsLookupFor2022.GPWCoverage
FROM         GPWContracts INNER JOIN
                      GPWContractsLookupFor2022 ON GPWContracts.Contract_Id = GPWContractsLookupFor2022.Contract_Id
					  left join (select Contract_Id from SentruityContractSplit2022 where SentruityContractSplit2022.Reinsurance_Type <> 'Warehouse' group by SentruityContractSplit2022.Contract_Id) ReinsuredContracts on ReinsuredContracts.Contract_Id = GPWContracts.Contract_Id
WHERE (GPWContractsLookupFor2022.GPWCoverage='RLA_1st' or GPWContractsLookupFor2022.GPWCoverage='RLA_Ex' and GPWContracts.Insurance_Carrier <> 'LTW')  and ReinsuredContracts.Contract_Id is null

--2/17/2022 --some reinsured SDC_1st contracts are getting sent to SDC_Ex here. Affects Just the tip reinsurance which was warehoused in 2020. Added check on if the contract is reinsured.
UPDATE GPWContracts
SET GPWContracts.GPWCoverage = GPWContractsLookupFor2022.GPWCoverage
FROM         GPWContracts INNER JOIN
                      GPWContractsLookupFor2022 ON GPWContracts.Contract_Id = GPWContractsLookupFor2022.Contract_Id
					  left join (select Contract_Id from SentruityContractSplit2022 where SentruityContractSplit2022.Reinsurance_Type <> 'Warehouse' group by SentruityContractSplit2022.Contract_Id) ReinsuredContracts on ReinsuredContracts.Contract_Id = GPWContracts.Contract_Id
WHERE (GPWContractsLookupFor2022.GPWCoverage='SDC_1st' or GPWContractsLookupFor2022.GPWCoverage='SDC_Ex') and ReinsuredContracts.Contract_Id is null

--Added GPWCoverage for Tripac
--5/1/2023: After discussion with Sentruity, they are treating TRipac as 100% first dollar.
update GPWContracts
set GPWCoverage = 'TRIPAC_1st'
where Insurance_Carrier = 'TRIPAC'

UPDATE GPWContracts
SET GPWContracts.EarnedQuarters = 41-[GPWEffectiveQtr#]
WHERE GPWContractCount=1 and GPWCancelCount=0
UPDATE GPWContracts
SET GPWContracts.EarnedQuarters = [GPWRelativeCancelQtr]
WHERE GPWCancelCount=1
UPDATE GPWContracts
SET GPWContracts.[Earned%] = [Selected Curves].[Earned%]
FROM GPWContracts LEFT OUTER JOIN [Selected Curves] 
	ON GPWContracts.[GPW N/U/P] = [Selected Curves].[N/U/P]
		and GPWContracts.[GPWTermMonths] = [Selected Curves].[Term]
		and GPWContracts.[EarnedQuarters] = [Selected Curves].[EarnedQuarters]
WHERE GPWContractCount=1 and GPWCancelCount=0
UPDATE GPWContracts
SET GPWContracts.[Earned%] = 0
WHERE GPWContractCount=1 and GPWCancelCount=0 and GPWContracts.[EarnedQuarters]<1
UPDATE GPWContracts
SET GPWContracts.[Earned%] = 1
WHERE GPWContractCount=1 and GPWCancelCount=0 and GPWContracts.[EarnedQuarters]>40
UPDATE GPWContracts
SET GPWContracts.[Earned%] = CASE WHEN [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 THEN 0 ELSE [Claim_Reserve_Earned]/([Base_Claim_Reserve]+[Surcharge_Reserve]) END
WHERE GPWCancelCount=1
UPDATE GPWContracts
SET GPWContracts.GPWMMEarned = [GPWActiveReserve]*[Earned%]
WHERE GPWContractCount=1 and GPWCancelCount=0
UPDATE GPWContracts
SET GPWContracts.GPWMMEarned = [GPWCancelReserve]
WHERE GPWCancelCount=1


UPDATE GPWContracts
SET GPWContracts.GPWSentruityInsured = coalesce(GPWContractsLookupFor2022.GPWSentruityInsured,1)
FROM         dbo.GPWContracts LEFT OUTER JOIN
                      dbo.GPWContractsLookupFor2022 ON dbo.GPWContracts.Contract_Id = dbo.GPWContractsLookupFor2022.Contract_Id
WHERE GPWContracts.GPWCoverage<>'LTW_1st' and GPWContracts.GPWCoverage<>'MTNG_1st' and GPWContracts.GPWCoverage<>'MTL_1st' and GPWContracts.Insurance_Carrier<>'GWAN'

UPDATE GPWContracts
SET GPWContracts.GPWSentruityInsured = 1
FROM      dbo.GPWContracts INNER JOIN
                      dbo.SentruityContractSplit2022List ON dbo.GPWContracts.Contract_Number = dbo.SentruityContractSplit2022List.Contract_Number
WHERE (GPWContracts.GPWCoverage='LTW_1st' or GPWContracts.GPWCoverage='MTNG_1st')
and SentruityContractSplit2022List.Ceding_Company_Abr = 'SEN'

UPDATE GPWContracts
SET GPWContracts.GPWSentruityInsured = 1
FROM      dbo.GPWContracts INNER JOIN
                      dbo.SentruityContractSplit2022List ON dbo.GPWContracts.Contract_Number = dbo.SentruityContractSplit2022List.Contract_Number
WHERE (GPWContracts.GPWCoverage='MTL_1st') and not SentruityContractSplit2022List.Reinsurer like '%NCFC07%'
and SentruityContractSplit2022List.Ceding_Company_Abr = 'SEN'


UPDATE GPWContracts
SET GPWContracts.GPWSentruityInsured = 1
FROM      dbo.GPWContracts
WHERE GPWContracts.GPWCoverage='LTW_1st' AND GPWContracts.[GPWDealer]='PA108'  


--Rockwall GS Re 2 PPM contracts that are being labeled sentruity insured due to their carrier and joining on the reinsurance table. These are not insured by sentruity. Manually set to 0. 5793 as of 12/31/20
update GPWContracts
set GPWContracts.GPWSentruityInsured = 0
from GPWContracts
where GPWSentruityInsured = 1 and GPWDealer in ('OR104','42302') and Plan_Code in ('P6','P7')

--Mike Calvert Contracts not insured by sentruity. 313 as of 12/31/20
update GPWContracts
set GPWSentruityInsured = 0
from GPWContracts
where GPWSentruityInsured = 1 and GPWDealer in ('42138') and Rate_Book = '968'

--Adding in TRIPAC for sentruityinsured check
update GPWContracts
set GPWSentruityInsured = 1
from GPWContracts
where Insurance_Carrier = 'TRIPAC'


UPDATE GPWContracts
SET GPWContracts.GPWReinsurer = SentruityContractSplit2022List.Reinsurer
FROM         dbo.GPWContracts INNER JOIN
                      dbo.SentruityContractSplit2022List ON GPWContracts.Contract_Number = dbo.SentruityContractSplit2022List.Contract_Number
WHERE    SentruityContractSplit2022List.Ceding_Company_Abr = 'SEN'
and SentruityContractSplit2022List.Reinsurance_Type <> 'Warehouse'



UPDATE GPWContracts
SET GPWContracts.GPWReinsurer = GPW_ReinsurerGrouping.GPWReinsuranceCompanyName
FROM         dbo.GPWContracts INNER JOIN
                      dbo.SentruityContractSplit2022 ON GPWContracts.Contract_Number = dbo.SentruityContractSplit2022.[Contract_Number] INNER JOIN
                      dbo.GPW_ReinsurerGrouping ON dbo.SentruityContractSplit2022.Ceding_Company_Abr = dbo.GPW_ReinsurerGrouping.Ceding_Company_Name AND 
                      dbo.SentruityContractSplit2022.Reinsurance_Company_Name = dbo.GPW_ReinsurerGrouping.Reinsurance_Company_Name
WHERE SentruityContractSplit2022.Ceding_Company_Abr = 'SEN'
AND	((dbo.GPW_ReinsurerGrouping.GPWReinsuranceCompanyName = 'Emerald Bay') OR
        (dbo.GPW_ReinsurerGrouping.GPWReinsuranceCompanyName = 'GS Re') OR
        (dbo.GPW_ReinsurerGrouping.GPWReinsuranceCompanyName = 'Retained') OR
        (dbo.GPW_ReinsurerGrouping.GPWReinsuranceCompanyName = 'Stonebridge') OR
        (dbo.GPW_ReinsurerGrouping.GPWReinsuranceCompanyName = 'Tricor'))
and GPW_ReinsurerGrouping.Reinsurance_Type <> 'Warehouse'


UPDATE GPWContracts
SET GPWContracts.GPWReinsurer = GPWContractsLookupFor2022.GPWReinsurer
FROM         GPWContracts INNER JOIN
                      GPWContractsLookupFor2022 ON GPWContracts.Contract_Id = GPWContractsLookupFor2022.Contract_Id
WHERE GPWContractsLookupFor2022.GPWReinsurer='Stonebridge'

update GPWContracts
set GPWCoverage = GPWContractsLookupFor2022.GPWCoverage
FROM         GPWContracts INNER JOIN
                      GPWContractsLookupFor2022 ON GPWContracts.Contract_Id = GPWContractsLookupFor2022.Contract_Id
WHERE GPWContractsLookupFor2022.GPWReinsurer='Stonebridge' and GPWContracts.GPWCoverage in ('CCC_Ex','TEC_Ex')


UPDATE GPWContracts
SET GPWContracts.GPWReinsurer = SentruityContractSplit2022List.Reinsurer
FROM         dbo.GPWContracts INNER JOIN
                      dbo.SentruityContractSplit2022List ON GPWContracts.Contract_Number = dbo.SentruityContractSplit2022List.Contract_Number
WHERE     SentruityContractSplit2022List.Ceding_Company_Abr = 'SEN'
			AND (SentruityContractSplit2022List.Reinsurer='Trotter Reinsurance Company, Ltd.')

--Sending Greg Leblanc to Retained. Should stay 1st dollar
update GPWContracts
set GPWReinsurer = 'Retained'
where GPWContracts.GPWReinsurer = 'Greg Leblanc Reinsurance Company, Ltd.'


UPDATE GPWContracts
SET GPWContracts.[GPWReinsurer] = 'OIC50'
FROM         dbo.GPWContracts INNER JOIN
                      dbo.[OICContracts50Perc] ON dbo.GPWContracts.Contract_Number = dbo.[OICContracts50Perc].[Contract]
WHERE GPWContracts.[GPWCoverage] = 'GWGS_1st'

UPDATE GPWContracts
SET GPWContracts.[GPWReinsurer] = 'OIC75'
FROM         dbo.GPWContracts INNER JOIN
                      dbo.[OICContracts75Perc] ON dbo.GPWContracts.Contract_Number = dbo.[OICContracts75Perc].[Contract]
WHERE GPWContracts.[GPWCoverage] = 'GWGS_1st'

UPDATE GPWContracts	
SET GPWContracts.[GPWReinsurer] = 'ANIC50'
FROM         dbo.GPWContracts INNER JOIN
                      dbo.[ANICContracts50Perc] ON dbo.GPWContracts.Contract_Number = dbo.[ANICContracts50Perc].[Contract]
WHERE GPWContracts.[GPWCoverage] = 'GWGS_1st'


UPDATE GPWContracts
SET GPWContracts.[GPWReinsurer] = 'GSCC'
FROM         dbo.GPWContracts
WHERE      (GPWCoverage = 'TGG_CCC_1st' OR GPWCoverage='TGG_TEC_1st')

UPDATE GPWContracts
SET GPWContracts.[GPWReinsurer] = 'Retained'
FROM         dbo.GPWContracts
WHERE      GPWCoverage = 'SDC_Ex'


UPDATE GPWContracts
SET GPWContracts.[GPWReinsurer] = 'GS Re Retro'
FROM      dbo.GPWContracts INNER JOIN
                      dbo.GPWContractsLookupFor2022 ON dbo.GPWContracts.Contract_Id = dbo.GPWContractsLookupFor2022.Contract_Id
WHERE  (dbo.GPWContractsLookupFor2022.GPWReinsurer = 'GS Re Retro')


UPDATE GPWContracts
SET GPWContracts.[GPWReinsurer] = 'TMIC'
FROM         dbo.GPWContracts
WHERE      GPWCoverage = 'EXTN_1st'
and [GPWEffectiveDate]<'9/1/2018' -- RDH added for 12/31/2018 analysis

----12/31/2021 IR: Some EXTN contracts are now reinsured. Add check on reinsured status
UPDATE GPWContracts
SET GPWContracts.[GPWReinsurer] = 'Retained'
FROM         dbo.GPWContracts
left join (select GPWContracts.Contract_Id
from GPWContracts
inner join SentruityContractSplit2022 on GPWContracts.Contract_Id = SentruityContractSplit2022.Contract_Id
where GPWContracts.GPWCoverage = 'EXTN_1st'
group by GPWContracts.Contract_Id) Ceded_Extn1stContracts on Ceded_Extn1stContracts.Contract_Id = GPWContracts.Contract_Id
WHERE      GPWCoverage = 'EXTN_1st'
and [GPWEffectiveDate]>='8/31/2018' -- RDH added for 12/31/2018 analysis
and Ceded_Extn1stContracts.Contract_Id is null

------12/31/2017 Seperating GS RE------------------
--Updated 2/17/22 to check that reinsurance type = GSRe2 instead of checking if the name has a 2 in it as some gs re 3 reinsurers had a 2 in them
Update gpwcontracts 
set GPWReinsurer = 'GS Re2'
From gpwcontracts 
  Left join [SentruityContractSplit2022]
  on gpwcontracts.Contract_Number = [SentruityContractSplit2022].Contract_Number
  where SentruityContractSplit2022.Reinsurance_Type = 'NCFC-GS Re 2'
  and GPWReinsurer = 'GS Re'

--Added by IR 2/4/2021 for 12/31/2019 analysis. Splitting out GS Re 3--Updated 2/17/22 to check that reinsurance type = GSRe3 instead of checking if the name has a 3 in it
Update gpwcontracts 
set GPWReinsurer = 'GS Re3'
From gpwcontracts 
  Left join [SentruityContractSplit2022]
  on gpwcontracts.Contract_Number = [SentruityContractSplit2022].Contract_Number
  where SentruityContractSplit2022.Reinsurance_Type = 'NCFC-GS Re 3'
  and GPWReinsurer = 'GS Re'

--Added by IR 2/4/2021 for 12/31/2020 analysis
update GPWContracts
set GPWContracts.GPWReinsurer = 'GS Re Retro'
from GPWContracts
inner join Tbl_NewGSReRetroLookup on GPWDealer = DealerNumber and Carrier = Insurance_Carrier
where GPWEffectiveDate BETWEEN '10-1-2018' and '12-31-2019'

--Added by IR 2/7/2023 to account for Technology Insurance Company. Sen cedes to TIC and TIC cedes that business out to 3 other rics
--Running separate triangles on the TIC business
update GPWContracts
set GPWReinsurer = 'TIC'
from GPWContracts
inner join SentruityContractSplit2022 on GPWContracts.Contract_Number = SentruityContractSplit2022.Contract_Number
where SentruityContractSplit2022.Reinsurance_Company_Name = 'Technology Insurance Company, Inc.'

--Added 2/21/2023 to account for retained TOLW. These are not sentruity insured and according to profit mapping there is no premium for retained TOLW business
update GPWContracts
set GPWSentruityInsured = 0
where Insurance_Carrier = 'TOLW'
and GPWReinsurer = 'Retained'

--Added 2/22/2023 to account for retroactive reinsurers that were new for 2022. Everything sold on these 7 reinsurers before December, 2022 are retained
--The TOLW Contracts associated with this will then retained their gpwsentruityinsured = 1 from the above update
update GPWContracts
set GPWReinsurer = 'Retained'
from GPWContracts
where GPWReinsurer in ('4 Rocking Girls Reinsurance, Ltd.'
,'Bewrite Reinsurance, Ltd.'
,'Charles Hamilton Wayne Reinsurance Company, Ltd.'
,'NMHMR Reinsurance, Ltd.'
,'Shelby Wayne 2 Reinsurance, Ltd.'
,'SRCT 3 Reinsurance, Ltd.'
,'Triple Re, Limited')
and EOMONTH(Contract_Sale_Date) < '12/31/2022'

--Added 2/22/2023 to account for reinsured TRIPAC contracts
update GPWContracts
set GPWReinsurer = case when Production_Source = 'Reinsurance' then 'TRIPAC' else 'Retained' end
where Insurance_Carrier = 'TRIPAC'

--4/24/2023: Manually mapping contracts under DOWC carrier and TX774 Dealer to RRG_1st retained.
--This business will now flow through the RRG_1st retained triangle now
update GPWContracts
set GPWCoverage = 'RRG_1st'
, GPWReinsurer = 'Retained'
, Insurance_Carrier = 'RRG'
where Insurance_Carrier = 'DOWC'
and GPWDealer = 'TX774'

------------------------------------------------------------
UPDATE GPWContracts
SET GPWNetReserves = (GPWActiveReserve + GPWCancelReserve) 
FROM         dbo.GPWContracts 

UPDATE GPWContracts
SET GPWEarnedReserves = GPWCancelReserve 
FROM         dbo.GPWContracts 
Where GPWCancelReserve<>0

UPDATE GPWContracts
SET GPWEarnedReserves = [Claim_Reserve_Earned] 
FROM         dbo.GPWContracts 
Where GPWActiveReserve<>0

UPDATE GPWContracts
SET GPWUnearnedReserves = GPWNetReserves - GPWEarnedReserves
FROM         dbo.GPWContracts 
---------------------------------------------------------------


UPDATE GPWContracts
SET GPWSentruityGrossPrem = ([Base_Claim_Reserve] + [Surcharge_Reserve]) * dbo.PremiumAdjustments.SentruityPrem * GPWContractCount
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     PremiumAdjustments.[DollarVsPerc]='P'


UPDATE GPWContracts
SET GPWSentruityGrossPrem = ([Base_Claim_Reserve] + [Surcharge_Reserve] + [Admin_5] + [Admin_7]) * GPWContractCount
FROM      dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'RRG_1st' OR GPWContracts.GPWCoverage = 'LTW_1st')


--IR 2/19/2023 GWGS carrier set to reserve + admin 5 + when CFC/NCFC Dealer then admin 7
--Direct Dealers are those from retained, ANIC, OIC dealers
update GPWContracts
SET GPWSentruityGrossPrem = ([Base_Claim_Reserve] + [Surcharge_Reserve] + [Admin_5] + case when GPWReinsurer not in ('ANIC50','OIC50','OIC75','Retained') then [Admin_7] else 0 end) * GPWContractCount
FROM      dbo.GPWContracts 
where Insurance_Carrier = 'GWGS'

--RDH added 5/27/2021

UPDATE GPWContracts
SET GPWSentruityGrossPrem = ([Base_Claim_Reserve] + [Surcharge_Reserve] + [Admin_5] + [Admin_7]) * GPWContractCount
FROM      dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'EXTN_1st' AND GPWContracts.GPWReinsurer <> 'TMIC') 

--IR 2/9/2023 Added to more easily account for new carriers that follow the standard base + surcharge + admin 5 + admin 7
UPDATE GPWContracts
SET GPWSentruityGrossPrem = ([Base_Claim_Reserve] + [Surcharge_Reserve] + [Admin_5] + [Admin_7]) * GPWContractCount
FROM      dbo.GPWContracts 
left join PremiumAdjustments on GPWContracts.GPWCoverage = PremiumAdjustments.GPWCoverage
and GPWContracts.Insurance_Carrier = PremiumAdjustments.Insurance_Carrier
where PremiumAdjustments.ReserveAdj = 1
and PremiumAdjustments.SentruityPrem = 1
and PremiumAdjustments.DollarVsPerc = 'P'
and PremiumAdjustments.Admin5Factor = 1
and PremiumAdjustments.Admin7Factor = 1

UPDATE GPWContracts
SET GPWSentruityGrossPrem = [Dealer_Remittance] * GPWContractCount
FROM      dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'GAPS_1st') and GPWContracts.Insurance_Carrier <> 'GAPA'



UPDATE GPWContracts
SET GPWSentruityGrossPrem = dbo.PremiumAdjustments.SentruityPrem * GPWContractCount
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     PremiumAdjustments.[DollarVsPerc]='D'


UPDATE GPWContracts
SET GPWSentruityGrossPrem = ([Base_Claim_Reserve] + [Surcharge_Reserve]) + (dbo.PremiumAdjustments.SentruityPrem * GPWContractCount)
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     GPWContracts.GPWCoverage = 'MTNG_1st'


UPDATE GPWContracts
SET GPWSentruityNetPrem = (GPWActiveReserve + GPWCancelReserve) * dbo.PremiumAdjustments.SentruityPrem
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     PremiumAdjustments.[DollarVsPerc]='P'


UPDATE GPWContracts
SET GPWSentruityNetPrem = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ((GPWActiveReserve + GPWCancelReserve)/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) end
FROM      dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'RRG_1st' OR GPWContracts.GPWCoverage = 'LTW_1st')

--IR 2/19/2023 GWGS carrier set to reserve + admin 5 + when CFC/NCFC Dealer then admin 7
UPDATE GPWContracts
SET GPWSentruityNetPrem = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ((GPWActiveReserve + GPWCancelReserve)/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+case when GPWReinsurer not in ('ANIC50','OIC50','OIC75','Retained') then [Admin_7] else 0 end) end
FROM dbo.GPWContracts 
WHERE Insurance_Carrier = 'GWGS'

--RDH added 5/27/2021, updated 12/31/21 IR to account for reinsured EXTN business
UPDATE GPWContracts
SET GPWSentruityNetPrem = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ((GPWActiveReserve + GPWCancelReserve)/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) end
FROM      dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'EXTN_1st' AND GPWContracts.GPWReinsurer <> 'TMIC') 

--IR 2/9/2023 Added to more easily account for new carriers that follow the standard base + surcharge + admin 5 + admin 7
UPDATE GPWContracts
SET GPWSentruityNetPrem = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ((GPWActiveReserve + GPWCancelReserve)/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) end
FROM      dbo.GPWContracts 
left join PremiumAdjustments on GPWContracts.GPWCoverage = PremiumAdjustments.GPWCoverage
and GPWContracts.Insurance_Carrier = PremiumAdjustments.Insurance_Carrier
where PremiumAdjustments.ReserveAdj = 1
and PremiumAdjustments.SentruityPrem = 1
and PremiumAdjustments.DollarVsPerc = 'P'
and PremiumAdjustments.Admin5Factor = 1
and PremiumAdjustments.Admin7Factor = 1

UPDATE GPWContracts
SET GPWSentruityNetPrem = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ((GPWActiveReserve + GPWCancelReserve)/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Dealer_Remittance]) end 
FROM      dbo.GPWContracts 
WHERE     GPWContracts.GPWCoverage = 'GAPS_1st' and GPWContracts.Insurance_Carrier <> 'GAPA'


--12/31/21 IR: Ajusted to account for new Ancillary Contracts
UPDATE GPWContracts
SET GPWSentruityNetPrem = dbo.PremiumAdjustments.SentruityPrem * (GPWContractCount - GPWCancelCount)
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     GPWContracts.GPWCoverage = 'ADMO_Ex' 
or GPWContracts.GPWCoverage = 'JWTW_Ex' 
OR GPWContracts.GPWCoverage = 'DOWC_Ex' 
OR GPWContracts.GPWCoverage = 'DOWH_Ex' 
OR GPWContracts.GPWCoverage = 'DWPM_Ex' 
OR GPWContracts.GPWCoverage = 'DWTW_Ex' 
OR GPWContracts.GPWCoverage = 'DTWH_Ex' 
or GPWContracts.Insurance_Carrier in('DWAP','DWAU','DWBD','DWBU','DWFG','DTWH','WHAU','WHBD','WHDC') 

--12/31/21 added ltws. Clip fee looks to be based on gross counts not net according to reserve workbook
UPDATE GPWContracts
SET GPWSentruityNetPrem = dbo.PremiumAdjustments.SentruityPrem * GPWContractCount 
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     GPWContracts.GPWCoverage = 'DLRO_Ex'  or GPWContracts.Insurance_Carrier = 'LTWS'


UPDATE GPWContracts
SET GPWSentruityNetPrem = (GPWActiveReserve + GPWCancelReserve) + (dbo.PremiumAdjustments.SentruityPrem * GPWContractCount)
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     GPWContracts.GPWCoverage = 'MTNG_1st'





UPDATE GPWContracts
SET GPWSentruityRefunds = [Refund_Reserve_Amount] * dbo.PremiumAdjustments.SentruityPrem * GPWContractCount
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     PremiumAdjustments.[DollarVsPerc]='P'


UPDATE GPWContracts
SET GPWSentruityRefunds = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Refund_Reserve_Amount]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) * GPWContractCount end
FROM      dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'RRG_1st' OR GPWContracts.GPWCoverage = 'LTW_1st')

--IR 2/19/2023 GWGS carrier set to reserve + admin 5 + when CFC/NCFC Dealer then admin 7
--Direct Dealers are those from retained, ANIC, OIC dealers
UPDATE GPWContracts
SET GPWSentruityRefunds = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Refund_Reserve_Amount]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+ case when GPWReinsurer not in ('ANIC50','OIC50','OIC75','Retained') then [Admin_7] else 0 end) * GPWContractCount end
FROM      dbo.GPWContracts 
WHERE Insurance_Carrier = 'GWGS'


--RDH added 5/27/2021, updated 12/31/21 IR to account for reinsured EXTN business
UPDATE GPWContracts
SET GPWSentruityRefunds = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Refund_Reserve_Amount]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) * GPWContractCount end
FROM      dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'EXTN_1st' AND GPWContracts.GPWReinsurer <> 'TMIC') 

--IR 2/9/2023 Added to more easily account for new carriers that follow the standard base + surcharge + admin 5 + admin 7
UPDATE GPWContracts
SET GPWSentruityRefunds = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Refund_Reserve_Amount]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) * GPWContractCount end
FROM      dbo.GPWContracts 
left join PremiumAdjustments on GPWContracts.GPWCoverage = PremiumAdjustments.GPWCoverage
and GPWContracts.Insurance_Carrier = PremiumAdjustments.Insurance_Carrier
where PremiumAdjustments.ReserveAdj = 1
and PremiumAdjustments.SentruityPrem = 1
and PremiumAdjustments.DollarVsPerc = 'P'
and PremiumAdjustments.Admin5Factor = 1
and PremiumAdjustments.Admin7Factor = 1

UPDATE GPWContracts
SET GPWSentruityRefunds = case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Refund_Reserve_Amount]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Dealer_Remittance]) * GPWContractCount end
FROM      dbo.GPWContracts 
WHERE     GPWContracts.GPWCoverage = 'GAPS_1st' and GPWContracts.Insurance_Carrier <> 'GAPA'


UPDATE GPWContracts
SET GPWSentruityRefunds = [Refund_Reserve_Amount] * GPWContractCount
FROM         dbo.GPWContracts 
WHERE     GPWContracts.GPWCoverage = 'MTNG_1st'

--12/31/21 IR: Ajusted to account for new Ancillary Contracts
UPDATE GPWContracts
SET GPWSentruityRefunds = dbo.PremiumAdjustments.SentruityPrem * GPWCancelCount
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     GPWContracts.GPWCoverage = 'ADMO_Ex' 
or GPWContracts.GPWCoverage = 'JWTW_Ex' 
OR GPWContracts.GPWCoverage = 'DOWC_Ex' 
OR GPWContracts.GPWCoverage = 'DOWH_Ex' 
OR GPWContracts.GPWCoverage = 'DWPM_Ex' 
OR GPWContracts.GPWCoverage = 'DWTW_Ex' 
OR GPWContracts.GPWCoverage = 'DTWH_Ex' 
or GPWContracts.Insurance_Carrier in('DWAP','DWAU','DWBD','DWBU','DWFG','DTWH','WHAU','WHBD','WHDC') 



UPDATE GPWContracts
SET GPWSentruityEarnedPrem = [Claim_Reserve_Earned] * dbo.PremiumAdjustments.SentruityPrem
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     right(GPWContracts.GPWCoverage,3) = '1st' and GPWSentruityInsured=1 and GPWContractCount=1
					and GPWContracts.GPWCoverage <> 'LTW_1st' and GPWContracts.GPWCoverage <> 'MTNG_1st' and GPWContracts.Insurance_Carrier not in ('ANBD','ANBU','APP','APPU')


UPDATE GPWContracts
SET GPWSentruityEarnedPrem = Case when GPWActiveReserve + GPWCancelReserve = 0 then 0 else [Claim_Reserve_Earned] + (([Claim_Reserve_Earned]/(GPWActiveReserve + GPWCancelReserve)) * (dbo.PremiumAdjustments.SentruityPrem * GPWContractCount)) end
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     right(GPWContracts.GPWCoverage,3) = '1st' and GPWSentruityInsured=1 and GPWContractCount=1
					and (GPWContracts.GPWCoverage = 'MTNG_1st')

UPDATE GPWContracts
SET GPWSentruityEarnedPrem = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Claim_Reserve_Earned]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) end
FROM      dbo.GPWContracts 
WHERE     GPWSentruityInsured=1 and GPWContractCount=1
	and (GPWContracts.GPWCoverage = 'RRG_1st' OR GPWContracts.GPWCoverage = 'LTW_1st')

--IR 2/19/2023 GWGS carrier set to reserve + admin 5 + when CFC/NCFC Dealer then admin 7
--Direct Dealers are those from retained, ANIC, OIC dealers
UPDATE GPWContracts
SET GPWSentruityEarnedPrem = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Claim_Reserve_Earned]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+case when GPWReinsurer not in ('ANIC50','OIC50','OIC75','Retained') then [Admin_7] else 0 end) end
FROM      dbo.GPWContracts 
WHERE     GPWSentruityInsured=1 and GPWContractCount=1
	and Insurance_Carrier = 'GWGS'

--RDH added 5/27/2021, updated 12/31/21 IR to account for reinsured EXTN business
UPDATE GPWContracts
SET GPWSentruityEarnedPrem = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Claim_Reserve_Earned]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) end
FROM      dbo.GPWContracts 
WHERE     GPWSentruityInsured=1 and GPWContractCount=1
and (GPWContracts.GPWCoverage = 'EXTN_1st' AND GPWContracts.GPWReinsurer <> 'TMIC') 

--IR 2/9/2023 Added to more easily account for new carriers that follow the standard base + surcharge + admin 5 + admin 7
UPDATE GPWContracts
SET GPWSentruityEarnedPrem = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Claim_Reserve_Earned]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) end
FROM      dbo.GPWContracts 
left join PremiumAdjustments on GPWContracts.GPWCoverage = PremiumAdjustments.GPWCoverage
and GPWContracts.Insurance_Carrier = PremiumAdjustments.Insurance_Carrier
where PremiumAdjustments.ReserveAdj = 1
and PremiumAdjustments.SentruityPrem = 1
and PremiumAdjustments.DollarVsPerc = 'P'
and PremiumAdjustments.Admin5Factor = 1
and PremiumAdjustments.Admin7Factor = 1


UPDATE GPWContracts
SET GPWSentruityEarnedPrem = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Claim_Reserve_Earned]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Dealer_Remittance]) end
FROM      dbo.GPWContracts 
WHERE     GPWSentruityInsured=1 and GPWContractCount=1
	and GPWContracts.GPWCoverage = 'GAPS_1st' and GPWContracts.Insurance_Carrier <> 'GAPA'


------------


UPDATE GPWContracts
SET GPWSentruityUnearnedPrem = GPWSentruityNetPrem - GPWSentruityEarnedPrem
FROM         dbo.GPWContracts 
WHERE     right(GPWContracts.GPWCoverage,3) = '1st' and GPWSentruityInsured=1 and GPWContractCount=1
-------------------------------------------------------------------------------------------------------------------------



UPDATE GPWContracts
SET GrossReserveAdj = ([Base_Claim_Reserve] + [Surcharge_Reserve]) * dbo.PremiumAdjustments.ReserveAdj
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     GPWContracts.GPWCoverage <> 'LTW_1st' and GPWContracts.GPWCoverage <> 'MTNG_1st'

UPDATE GPWContracts
SET RefundReserveAdj = [Refund_Reserve_Amount] * dbo.PremiumAdjustments.ReserveAdj
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     GPWContracts.GPWCoverage <> 'LTW_1st' and GPWContracts.GPWCoverage <> 'MTNG_1st'

UPDATE GPWContracts
SET NetReserveAdj = GrossReserveAdj - RefundReserveAdj 
FROM         dbo.GPWContracts 
WHERE     GPWContracts.GPWCoverage <> 'LTW_1st' and GPWContracts.GPWCoverage <> 'MTNG_1st'

UPDATE GPWContracts
SET EarnedReserveAdj = [Claim_Reserve_Earned] * dbo.PremiumAdjustments.ReserveAdj
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     GPWContracts.GPWCoverage <> 'LTW_1st' and GPWContracts.GPWCoverage <> 'MTNG_1st'

UPDATE GPWContracts
SET UnearnedReserveAdj = NetReserveAdj - EarnedReserveAdj
FROM         dbo.GPWContracts 
WHERE     GPWContracts.GPWCoverage <> 'LTW_1st' and GPWContracts.GPWCoverage <> 'MTNG_1st'

---------------------------------------------------------------------------------------------------------------
UPDATE GPWContracts
SET GrossReserveAdj = ([Base_Claim_Reserve] + [Surcharge_Reserve] + [Admin_5] + [Admin_7]) 
FROM      dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'RRG_1st' OR GPWContracts.GPWCoverage = 'LTW_1st')


UPDATE GPWContracts
SET RefundReserveAdj = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Refund_Reserve_Amount]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) end
FROM      dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'RRG_1st' OR GPWContracts.GPWCoverage = 'LTW_1st')


UPDATE GPWContracts
SET NetReserveAdj = GrossReserveAdj - RefundReserveAdj 
FROM         dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'RRG_1st' OR GPWContracts.GPWCoverage = 'LTW_1st')

UPDATE GPWContracts
SET EarnedReserveAdj = case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Claim_Reserve_Earned]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) end
FROM      dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'RRG_1st' OR GPWContracts.GPWCoverage = 'LTW_1st')

UPDATE GPWContracts
SET UnearnedReserveAdj = NetReserveAdj - EarnedReserveAdj
FROM         dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'RRG_1st' OR GPWContracts.GPWCoverage = 'LTW_1st')
---------------------------------------------------------------------------------------------------------------
--IR 2/19/2023 GWGS carrier set to reserve + admin 5 + when CFC/NCFC Dealer then admin 7
--Direct Dealers are those from retained, ANIC, OIC dealers
---------------------------------------------------------------------------------------------------------------
UPDATE GPWContracts
SET GrossReserveAdj = ([Base_Claim_Reserve] + [Surcharge_Reserve] + [Admin_5] + [Admin_7]) 
FROM      dbo.GPWContracts 
where Insurance_Carrier = 'GWGS'


UPDATE GPWContracts
SET RefundReserveAdj = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Refund_Reserve_Amount]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+case when GPWReinsurer not in ('ANIC50','OIC50','OIC75','Retained') then [Admin_7] else 0 end) end
FROM      dbo.GPWContracts 
where Insurance_Carrier = 'GWGS'


UPDATE GPWContracts
SET NetReserveAdj = GrossReserveAdj - RefundReserveAdj 
FROM         dbo.GPWContracts 
where Insurance_Carrier = 'GWGS'

UPDATE GPWContracts
SET EarnedReserveAdj = case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Claim_Reserve_Earned]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+case when GPWReinsurer not in ('ANIC50','OIC50','OIC75','Retained') then [Admin_7] else 0 end) end
FROM      dbo.GPWContracts 
where Insurance_Carrier = 'GWGS'

UPDATE GPWContracts
SET UnearnedReserveAdj = NetReserveAdj - EarnedReserveAdj
FROM         dbo.GPWContracts 
where Insurance_Carrier = 'GWGS'
---------------------------------------------------------------------------------------------------------------
--RDH added 5/27/2021, updated 12/31/21 IR to account for reinsured EXTN business, FGSC business
--Updated 2/8/2023 to add new triton carriers
---------------------------------------------------------------------------------------------------------------
UPDATE GPWContracts
SET GrossReserveAdj = ([Base_Claim_Reserve] + [Surcharge_Reserve] + [Admin_5] + [Admin_7]) 
FROM      dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'EXTN_1st' AND (GPWContracts.GPWReinsurer <> 'TMIC')) 


UPDATE GPWContracts
SET RefundReserveAdj = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Refund_Reserve_Amount]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) end
FROM      dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'EXTN_1st' AND GPWContracts.GPWReinsurer <> 'TMIC') 

UPDATE GPWContracts
SET NetReserveAdj = GrossReserveAdj - RefundReserveAdj 
FROM         dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'EXTN_1st' AND GPWContracts.GPWReinsurer <> 'TMIC') 

UPDATE GPWContracts
SET EarnedReserveAdj = case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Claim_Reserve_Earned]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) end
FROM      dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'EXTN_1st' AND GPWContracts.GPWReinsurer <> 'TMIC') 

UPDATE GPWContracts
SET UnearnedReserveAdj = NetReserveAdj - EarnedReserveAdj
FROM         dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'EXTN_1st' AND GPWContracts.GPWReinsurer <> 'TMIC') 

---------------------------------------------------------------------------------------------------------------
--IR 2/9/2023 Added to more easily account for new carriers that follow the standard base + surcharge + admin 5 + admin 7

UPDATE GPWContracts
SET GrossReserveAdj = ([Base_Claim_Reserve] + [Surcharge_Reserve] + [Admin_5] + [Admin_7]) 
FROM      dbo.GPWContracts 
left join PremiumAdjustments on GPWContracts.GPWCoverage = PremiumAdjustments.GPWCoverage
and GPWContracts.Insurance_Carrier = PremiumAdjustments.Insurance_Carrier
where PremiumAdjustments.ReserveAdj = 1
and PremiumAdjustments.SentruityPrem = 1
and PremiumAdjustments.DollarVsPerc = 'P'
and PremiumAdjustments.Admin5Factor = 1
and PremiumAdjustments.Admin7Factor = 1

UPDATE GPWContracts
SET RefundReserveAdj = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Refund_Reserve_Amount]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) end
FROM      dbo.GPWContracts 
left join PremiumAdjustments on GPWContracts.GPWCoverage = PremiumAdjustments.GPWCoverage
and GPWContracts.Insurance_Carrier = PremiumAdjustments.Insurance_Carrier
where PremiumAdjustments.ReserveAdj = 1
and PremiumAdjustments.SentruityPrem = 1
and PremiumAdjustments.DollarVsPerc = 'P'
and PremiumAdjustments.Admin5Factor = 1
and PremiumAdjustments.Admin7Factor = 1

UPDATE GPWContracts
SET NetReserveAdj = GrossReserveAdj - RefundReserveAdj 
FROM      dbo.GPWContracts 
left join PremiumAdjustments on GPWContracts.GPWCoverage = PremiumAdjustments.GPWCoverage
and GPWContracts.Insurance_Carrier = PremiumAdjustments.Insurance_Carrier
where PremiumAdjustments.ReserveAdj = 1
and PremiumAdjustments.SentruityPrem = 1
and PremiumAdjustments.DollarVsPerc = 'P'
and PremiumAdjustments.Admin5Factor = 1
and PremiumAdjustments.Admin7Factor = 1


UPDATE GPWContracts
SET EarnedReserveAdj = case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Claim_Reserve_Earned]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) end
FROM      dbo.GPWContracts 
left join PremiumAdjustments on GPWContracts.GPWCoverage = PremiumAdjustments.GPWCoverage
and GPWContracts.Insurance_Carrier = PremiumAdjustments.Insurance_Carrier
where PremiumAdjustments.ReserveAdj = 1
and PremiumAdjustments.SentruityPrem = 1
and PremiumAdjustments.DollarVsPerc = 'P'
and PremiumAdjustments.Admin5Factor = 1
and PremiumAdjustments.Admin7Factor = 1


UPDATE GPWContracts
SET UnearnedReserveAdj = NetReserveAdj - EarnedReserveAdj
FROM      dbo.GPWContracts 
left join PremiumAdjustments on GPWContracts.GPWCoverage = PremiumAdjustments.GPWCoverage
and GPWContracts.Insurance_Carrier = PremiumAdjustments.Insurance_Carrier
where PremiumAdjustments.ReserveAdj = 1
and PremiumAdjustments.SentruityPrem = 1
and PremiumAdjustments.DollarVsPerc = 'P'
and PremiumAdjustments.Admin5Factor = 1
and PremiumAdjustments.Admin7Factor = 1

---------------------------------------------------------------------------------------------------------------
--2/9/2023 added check on GAPA
UPDATE GPWContracts
SET GrossReserveAdj = [Dealer_Remittance]  
FROM      dbo.GPWContracts 
WHERE     GPWContracts.GPWCoverage = 'GAPS_1st' and GPWContracts.Insurance_Carrier <> 'GAPA'


UPDATE GPWContracts
SET RefundReserveAdj = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0  then 0 else ([Refund_Reserve_Amount]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Dealer_Remittance]) end
FROM      dbo.GPWContracts 
WHERE     GPWContracts.GPWCoverage = 'GAPS_1st' and GPWContracts.Insurance_Carrier <> 'GAPA'

UPDATE GPWContracts
SET NetReserveAdj = GrossReserveAdj - RefundReserveAdj 
FROM         dbo.GPWContracts 
WHERE     GPWContracts.GPWCoverage = 'GAPS_1st' and GPWContracts.Insurance_Carrier <> 'GAPA'

UPDATE GPWContracts
SET EarnedReserveAdj = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else ([Claim_Reserve_Earned]/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Dealer_Remittance]) end
FROM      dbo.GPWContracts 
WHERE     GPWContracts.GPWCoverage = 'GAPS_1st' and GPWContracts.Insurance_Carrier <> 'GAPA'

UPDATE GPWContracts
SET UnearnedReserveAdj = NetReserveAdj - EarnedReserveAdj
FROM         dbo.GPWContracts 
WHERE     GPWContracts.GPWCoverage = 'GAPS_1st' and GPWContracts.Insurance_Carrier <> 'GAPA'
---------------------------------------------------------------------------------------------------------------

UPDATE GPWContracts
SET GrossReserveAdj = ([Base_Claim_Reserve] + [Surcharge_Reserve]) + dbo.PremiumAdjustments.ReserveAdj
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     GPWContracts.GPWCoverage = 'MTNG_1st'


UPDATE GPWContracts
SET RefundReserveAdj = [Refund_Reserve_Amount] 
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     GPWContracts.GPWCoverage = 'MTNG_1st'

UPDATE GPWContracts
SET NetReserveAdj = GrossReserveAdj - RefundReserveAdj 
FROM         dbo.GPWContracts 
WHERE     GPWContracts.GPWCoverage = 'MTNG_1st'

UPDATE GPWContracts
SET EarnedReserveAdj = [Claim_Reserve_Earned] + (([Claim_Reserve_Earned]/(GPWActiveReserve + GPWCancelReserve)) * dbo.PremiumAdjustments.ReserveAdj)
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     (GPWContracts.GPWCoverage = 'MTNG_1st') and (GPWActiveReserve + GPWCancelReserve)<>0

UPDATE GPWContracts
SET UnearnedReserveAdj = NetReserveAdj - EarnedReserveAdj
FROM         dbo.GPWContracts 
WHERE     GPWContracts.GPWCoverage = 'MTNG_1st'

---------------------------------------------------------------------------------------------------------------

UPDATE GPWContracts
SET GPWActiveReserve = GPWActiveReserve * dbo.PremiumAdjustments.ReserveAdj
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     NOT (GPWContracts.GPWCoverage = 'GWGS_1st' or GPWContracts.GPWCoverage = 'GAPS_1st' or GPWContracts.GPWCoverage = 'RRG_1st' or GPWContracts.GPWCoverage = 'LTW_1st' or GPWContracts.GPWCoverage = 'MTNG_1st')
and not (GPWContracts.GPWCoverage = 'EXTN_1st' AND GPWContracts.GPWReinsurer <> 'TMIC') --RDH added 5/27/2021, updated 12/31/21 IR to account for reinsured EXTN business

UPDATE GPWContracts
SET GPWCancelReserve = GPWCancelReserve * dbo.PremiumAdjustments.ReserveAdj
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     NOT (GPWContracts.GPWCoverage = 'GWGS_1st' or GPWContracts.GPWCoverage = 'GAPS_1st' or GPWContracts.GPWCoverage = 'RRG_1st' or GPWContracts.GPWCoverage = 'LTW_1st' or GPWContracts.GPWCoverage = 'MTNG_1st')
and not (GPWContracts.GPWCoverage = 'EXTN_1st' AND GPWContracts.GPWReinsurer <> 'TMIC') --RDH added 5/27/2021


UPDATE GPWContracts
SET GPWActiveReserve = case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else (GPWActiveReserve/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) end
FROM      dbo.GPWContracts 
WHERE     ((GPWContracts.GPWCoverage = 'RRG_1st' and Insurance_Carrier <>'CCFD') OR GPWContracts.GPWCoverage = 'LTW_1st')

UPDATE GPWContracts
SET GPWCancelReserve = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0  then 0 else (GPWCancelReserve/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) end
FROM      dbo.GPWContracts 
WHERE     ((GPWContracts.GPWCoverage = 'RRG_1st' and Insurance_Carrier <>'CCFD') OR GPWContracts.GPWCoverage = 'LTW_1st')

--IR 2/19/2023 GWGS carrier set to reserve + admin 5 + when CFC/NCFC Dealer then admin 7
--Direct Dealers are those from retained, ANIC, OIC dealers
UPDATE GPWContracts
SET GPWActiveReserve = case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else (GPWActiveReserve/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+case when GPWReinsurer not in ('ANIC50','OIC50','OIC75','Retained') then [Admin_7] else 0 end) end
FROM      dbo.GPWContracts 
where Insurance_Carrier = 'GWGS'

UPDATE GPWContracts
SET GPWCancelReserve = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0  then 0 else (GPWCancelReserve/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+case when GPWReinsurer not in ('ANIC50','OIC50','OIC75','Retained') then [Admin_7] else 0 end) end
FROM      dbo.GPWContracts 
where Insurance_Carrier = 'GWGS'


--RDH added 5/27/2021, updated 12/31/21 IR to account for reinsured EXTN business, FGSC business
--updated 2/8/2023 to add new triton carriers
UPDATE GPWContracts
SET GPWActiveReserve = case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else (GPWActiveReserve/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) end
FROM      dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'EXTN_1st' AND GPWContracts.GPWReinsurer <> 'TMIC')  

--RDH added 5/27/2021, updated 12/31/21 IR to account for reinsured EXTN business, FGSC business
--updated 2/8/2023 to add new triton carriers
UPDATE GPWContracts
SET GPWCancelReserve = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0  then 0 else (GPWCancelReserve/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) end
FROM      dbo.GPWContracts 
WHERE     (GPWContracts.GPWCoverage = 'EXTN_1st' AND GPWContracts.GPWReinsurer <> 'TMIC')  

--IR 2/9/2023 Added to more easily account for new carriers that follow the standard base + surcharge + admin 5 + admin 7
UPDATE GPWContracts
SET GPWActiveReserve = case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else (GPWActiveReserve/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) end
FROM      dbo.GPWContracts 
left join PremiumAdjustments on GPWContracts.GPWCoverage = PremiumAdjustments.GPWCoverage
and GPWContracts.Insurance_Carrier = PremiumAdjustments.Insurance_Carrier
where PremiumAdjustments.ReserveAdj = 1
and PremiumAdjustments.SentruityPrem = 1
and PremiumAdjustments.DollarVsPerc = 'P'
and PremiumAdjustments.Admin5Factor = 1
and PremiumAdjustments.Admin7Factor = 1

UPDATE GPWContracts
SET GPWCancelReserve = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0  then 0 else (GPWCancelReserve/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Base_Claim_Reserve]+[Surcharge_Reserve]+[Admin_5]+[Admin_7]) end
FROM      dbo.GPWContracts 
left join PremiumAdjustments on GPWContracts.GPWCoverage = PremiumAdjustments.GPWCoverage
and GPWContracts.Insurance_Carrier = PremiumAdjustments.Insurance_Carrier
where PremiumAdjustments.ReserveAdj = 1
and PremiumAdjustments.SentruityPrem = 1
and PremiumAdjustments.DollarVsPerc = 'P'
and PremiumAdjustments.Admin5Factor = 1
and PremiumAdjustments.Admin7Factor = 1


UPDATE GPWContracts
SET GPWActiveReserve = Case when [Base_Claim_Reserve]+[Surcharge_Reserve]=0 then 0 else (GPWActiveReserve/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Dealer_Remittance]) end
FROM      dbo.GPWContracts 
WHERE     GPWContracts.GPWCoverage = 'GAPS_1st' and GPWContracts.Insurance_Carrier <> 'GAPA'

UPDATE GPWContracts
SET GPWCancelReserve = Case when [Base_Claim_Reserve]+[Surcharge_Reserve] = 0 then 0 else (GPWCancelReserve/([Base_Claim_Reserve]+[Surcharge_Reserve])) * ([Dealer_Remittance]) end
FROM      dbo.GPWContracts 
WHERE     GPWContracts.GPWCoverage = 'GAPS_1st' and GPWContracts.Insurance_Carrier <> 'GAPA'



--------------------------------------------------------------------------------------------------------                      


UPDATE GPWContracts
SET GPWActiveReserve = GPWActiveReserve + dbo.PremiumAdjustments.ReserveAdj*GPWContractCount*(1-GPWCancelCount)
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     GPWContracts.GPWCoverage = 'MTNG_1st'

UPDATE GPWContracts
SET GPWCancelReserve = GPWCancelReserve + dbo.PremiumAdjustments.ReserveAdj*GPWCancelCount
FROM         dbo.GPWContracts INNER JOIN
                      dbo.PremiumAdjustments ON dbo.GPWContracts.Insurance_Carrier = dbo.PremiumAdjustments.Insurance_Carrier AND 
                      dbo.GPWContracts.GPWCoverage = dbo.PremiumAdjustments.GPWCoverage
WHERE     GPWContracts.GPWCoverage = 'MTNG_1st'

---------------------------------------------------------------------------------------------------

--Bringing in tripac reserves for triangle, premiums for 13 month rule
update GPWContracts
set GPWActiveReserve = cast(Reserve as float)
, GPWNetReserves = cast(Reserve as float)
, GPWSentruityNetPrem = cast(Premium1 as float)
from GPWContracts
left join RawData_Contracts_TriPac on Contract_Id = ltrim(rtrim(RawData_Contracts_TriPac.Contract)) + '_Tripac'
where Insurance_Carrier = 'TRIPAC' and GPWCoverage = 'TRIPAC_Ex'

------------------------------------------------------------------------------------------------------

UPDATE GPWContracts
SET GPWContracts.[GPW N/U/P] = 'Seg1_'
FROM      dbo.GPWContracts INNER JOIN
                      dbo.PlanCodes ON dbo.GPWContracts.Rate_Book = dbo.PlanCodes.Rate_Book AND 
                      dbo.GPWContracts.New_Used = dbo.PlanCodes.New_Used AND dbo.GPWContracts.Plan_Code = dbo.PlanCodes.Plan_Code
WHERE     (GPWContracts.GPWCoverage = 'MTNG_1st' OR GPWContracts.GPWCoverage = 'DWPM_Ex') and (LEFT(PlanCodes.Plan_Description,3)='375' OR LEFT(PlanCodes.Plan_Description,3)='5k ')


UPDATE GPWContracts
SET GPWContracts.[GPW N/U/P] = 'Seg2_'
FROM      dbo.GPWContracts INNER JOIN
                      dbo.PlanCodes ON dbo.GPWContracts.Rate_Book = dbo.PlanCodes.Rate_Book AND 
                      dbo.GPWContracts.New_Used = dbo.PlanCodes.New_Used AND dbo.GPWContracts.Plan_Code = dbo.PlanCodes.Plan_Code
WHERE     (GPWContracts.GPWCoverage = 'MTNG_1st' OR GPWContracts.GPWCoverage = 'DWPM_Ex') and (LEFT(PlanCodes.Plan_Description,3)='7.5' OR LEFT(PlanCodes.Plan_Description,3)='8K ')


UPDATE GPWContracts
SET GPWContracts.[GPW N/U/P] = 'Seg3_'
FROM      dbo.GPWContracts INNER JOIN
                      dbo.PlanCodes ON dbo.GPWContracts.Rate_Book = dbo.PlanCodes.Rate_Book AND 
                      dbo.GPWContracts.New_Used = dbo.PlanCodes.New_Used AND dbo.GPWContracts.Plan_Code = dbo.PlanCodes.Plan_Code
WHERE     (GPWContracts.GPWCoverage = 'MTNG_1st' OR GPWContracts.GPWCoverage = 'DWPM_Ex') and LEFT(PlanCodes.Plan_Description,3)='10K'

--IR 12/31/2022 splitting out 10k interval diesel class 8 maintenance plan codes
UPDATE GPWContracts
SET GPWContracts.[GPW N/U/P] = 'Seg4_'
FROM      dbo.GPWContracts INNER JOIN
                      dbo.PlanCodes ON dbo.GPWContracts.Rate_Book = dbo.PlanCodes.Rate_Book AND 
                      dbo.GPWContracts.New_Used = dbo.PlanCodes.New_Used AND dbo.GPWContracts.Plan_Code = dbo.PlanCodes.Plan_Code
WHERE     (GPWContracts.GPWCoverage = 'MTNG_1st') and GPWContracts.Plan_Code in ('C8','T8','X8') and PlanCodes.New_Used = 'U'

UPDATE GPWContracts
SET GPWContracts.[GPW N/U/P] = 'Seg1_'
FROM     dbo.GPWContracts 
WHERE  (dbo.GPWContracts.GPWCoverage = 'GWGS_1st' OR dbo.GPWContracts.GPWCoverage = 'GAPS_1st' OR dbo.GPWContracts.GPWCoverage = 'MLA_1st') and [GPW N/U/P]='N'

UPDATE GPWContracts
SET GPWContracts.[GPW N/U/P] = 'Seg2_'
FROM     dbo.GPWContracts 
WHERE  (dbo.GPWContracts.GPWCoverage = 'GWGS_1st' OR dbo.GPWContracts.GPWCoverage = 'GAPS_1st' OR dbo.GPWContracts.GPWCoverage = 'MLA_1st') and [GPW N/U/P]='U'

UPDATE GPWContracts
SET GPWContracts.[GPW N/U/P] = 'Seg3_'
FROM      dbo.GPWContracts INNER JOIN
                      dbo.PlanCodes ON dbo.GPWContracts.Rate_Book = dbo.PlanCodes.Rate_Book AND 
                      dbo.GPWContracts.New_Used = dbo.PlanCodes.New_Used AND dbo.GPWContracts.Plan_Code = dbo.PlanCodes.Plan_Code
WHERE  (dbo.GPWContracts.GPWCoverage = 'GWGS_1st' OR dbo.GPWContracts.GPWCoverage = 'GAPS_1st') AND (dbo.PlanCodes.Plan_Description LIKE '%LEASE%') 


--****************************************************
--AJD 12/31/2020 for higher mileage program contracts
UPDATE GPWContracts
SET [GPW N/U/P] = 'SaleDateP'
where [GPW N/U/P] = 'P' 
	and [plan_code] = 'U5' 
	and [Rate_Book] in ('1040','1041','1042','1046','1047','2048','2051','2054','2229')
	and GPWAgg_TEC = 'Y'

--UPDATE GPWContracts
--set [GPW N/U/P] = 'SaleDateP'
--where [GPW N/U/P] = 'P' 
--	and ([plan_code] = 'P2' or [plan_code]='PP') 
--	and GPWAgg_SNV = 'Y'

--IR 2/20/2023 broke out the SNV Program to low and high starting odometer bands
update GPWContracts
set [GPW N/U/P] = case when Sale_Odometer <= 36000 then 'LowOdometerProgram' else 'HighOdometerProgram' end
where [GPW N/U/P] = 'P'
and GPWAgg_SNV = 'Y'


UPDATE GPWContracts
set [GPW N/U/P] = 'SaleDateP'
where [GPW N/U/P] = 'P' 
	and [plan_code] = 'U2'
	and Rate_Book = '1040'
	and PlanGroup = 'TCUV'
--****************************************************

--IR 12/31/2021 Splitting out segments for Ancillary Products

update GPWContracts
set [GPW N/U/P] = 'AppearancePreload'
where GPWContracts.Insurance_Carrier in ('APP','DWAP')

update GPWContracts
set [GPW N/U/P] = 'AppearanceUpsell'
where GPWContracts.Insurance_Carrier in ('APPU','DWAU','WHAU')

update GPWContracts
set [GPW N/U/P] = 'BundlePreload'
where GPWContracts.Insurance_Carrier in ('ANBD','DWBD','WHBD')

update GPWContracts
set [GPW N/U/P] = 'BundleUpsell'
where GPWContracts.Insurance_Carrier in ('ANBU','DWBU')

--****************************************************

--IR 12/31/2022 splitting out the TRIPAC segments
--Brought in the segments as vehicle class

update GPWContracts
set [GPW N/U/P] = case when Vehicle_Class = 'IdentiCar' then 'Theft'
								when Vehicle_Class = 'Loyalty Maintenance' then 'Maintenance'
								when Vehicle_Class = 'Paintless Dent Repair' then 'Dent'
								when Vehicle_Class in ('Superior Finish','Ultimate') then 'Ultimate'
								else Vehicle_Class END
where Insurance_Carrier = 'TRIPAC'
GO
