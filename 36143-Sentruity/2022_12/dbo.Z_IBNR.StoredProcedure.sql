USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[Z_IBNR]    Script Date: 5/16/2023 9:50:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Z_IBNR] as


DECLARE @ValDate AS DATE, @BegDate AS DATE
Set @ValDate = (SELECT ValDate FROM TBL_DBVALUES)
Set @BegDate = (SELECT BegDate FROM TBL_DBVALUES)

IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'IBNR_MinPaidDate')
	DROP TABLE IBNR_MinPaidDate
--grouping by grouping into one paid date
select cl.Contract_Id as Contract_Id,
cl.Claim_Number as Claim_Number,
cl.Date_Loss_Occurred as lossDate,
min(cl.Date_Claim_Detail_Paid) as MinPaidDate,
1 as ClaimCount
into IBNR_MinPaidDate
from Claims cl 
left join GPWClaimsHarveyFlood clhf on cl.Contract_Id = clhf.Contract_Id and clhf.Claim_Number = cl.Claim_Number
left join GPWClaimsImeldaFlood Imelda on cl.Contract_Id = Imelda.Contract_Id and Imelda.Claim_Number = cl.Claim_Number
where clhf.Claim_Number is null
and Imelda.Claim_Number is null
AND cl.Date_Claim_Detail_Paid<=@ValDate and cl.Claim_Status<>'Open'
group by 
cl.Contract_Id,
cl.Claim_Number,
cl.Date_Loss_Occurred


IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'IBNR_UnionTemp')
	DROP TABLE IBNR_UnionTemp
--bringing in paid losses
select 
con.GPWCoverage,
year(cl.Date_Loss_Occurred) as ClaimYr,
month(cl.Date_Loss_Occurred) as ClaimMth,
year(cl.Date_Claim_Detail_Paid) as PaidYr,
month(cl.Date_Claim_Detail_Paid) as PaidMth,
cast(0 as float) as ClaimCnt,
sum(cl.Amount_Paid) as PaidLs
into IBNR_UnionTemp
from Claims cl
inner join GPWContracts con on cl.Contract_Id = con.Contract_Id
left join GPWClaimsHarveyFlood clhf on clhf.Contract_Id = cl.Contract_Id and clhf.Claim_Number = cl.Claim_Number
left join GPWClaimsImeldaFlood Imelda on Imelda.Contract_Id = cl.Contract_Id and Imelda.Claim_Number = cl.Claim_Number
where clhf.Claim_Number is null AND Imelda.Claim_Number is null AND cl.Date_Claim_Detail_Paid<=@ValDate and cl.Claim_Status<>'Open'
and (
((cl.Date_Loss_Occurred IS NOT NULL) AND (con.GPWContractCount = 1) AND (con.GPWSentruityInsured = 1) AND (con.GPWEffectiveYear >= year(@BegDate)))
OR
((cl.Date_Loss_Occurred IS NOT NULL) AND (con.GPWContractCount = 1) AND (LEFT(con.GPWCoverage, 3) = 'TGG') AND (con.GPWEffectiveYear >= year(@BegDate)))
)
group by 
con.GPWCoverage,
year(cl.Date_Loss_Occurred),
month(cl.Date_Loss_Occurred),
year(cl.Date_Claim_Detail_Paid),
month(cl.Date_Claim_Detail_Paid)

UNION ALL
--bringing in claimcounts
Select
con.GPWCoverage,
year(cl.lossDate) as ClaimYr,
month(cl.lossDate) as ClaimMth,
year(cl.MinPaidDate) as PaidYr,
month(cl.MinPaidDate) as PaidMth,
sum(ClaimCount) as ClaimCnt,
cast(0 as float) as PaidLs
from IBNR_MinPaidDate cl
inner join GPWContracts con on cl.Contract_Id = con.Contract_Id
left join GPWClaimsHarveyFlood clhf on clhf.Contract_Id = cl.Contract_Id and clhf.Claim_Number = cl.Claim_Number
left join GPWClaimsImeldaFlood Imelda on Imelda.Contract_Id = cl.Contract_Id and Imelda.Claim_Number = cl.Claim_Number
where clhf.Claim_Number is null AND Imelda.Claim_Number is null 
and (
((cl.lossDate IS NOT NULL) AND (con.GPWContractCount = 1) AND (con.GPWSentruityInsured = 1) AND (con.GPWEffectiveYear >= year(@BegDate)))
OR
((cl.lossDate IS NOT NULL) AND (con.GPWContractCount = 1) AND (LEFT(con.GPWCoverage, 3) = 'TGG') AND (con.GPWEffectiveYear >= year(@BegDate)))
)
group by 
con.GPWCoverage,
year(cl.lossDate),
month(cl.lossDate),
year(cl.MinPaidDate),
MONTH(cl.MinPaidDate)



IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'IBNR_Final')
	DROP TABLE IBNR_Final

Select 
ut.GPWCoverage as SqlCat1,
NULL as SqlCat2,
NULL as SqlCat3,
NULL as Sqlcat4,
NULL as Sqlcat5,
ClaimYr,
ClaimMth,
PaidYr,
PaidMth,
sum(ut.ClaimCnt) as ClaimCnt,
sum(ut.PaidLs) as PaidLs
INTO IBNR_Final
from IBNR_UnionTemp ut
group by 
ut.GPWCoverage,
ut.ClaimYr,
ut.ClaimMth,
ut.PaidYr,
ut.PaidMth


--From IBNR Final to analysis
select *
from IBNR_Final 
order by sqlcat1






GO
