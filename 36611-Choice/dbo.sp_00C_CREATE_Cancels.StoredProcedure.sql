USE [36611_202212_ChoiceHW]
GO
/****** Object:  StoredProcedure [dbo].[sp_00C_CREATE_Cancels]    Script Date: 5/17/2023 3:20:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_00C_CREATE_Cancels]
as


declare @valdate as date
set @valdate = (Select Valdate from Tbl_DBValues)

IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'Cancels')
	DROP TABLE Cancels


--AJD 10/31/2020 Cancels come in a new format but the old cancels are not changing.
--Old cancels are in a separate table so they do not have to get uploaded each time.

IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'RawData_Cancels')
	DROP TABLE RawData_Cancels

select 
[date] as [date]
,[custid] as [custid]
,[accttype] as [accttype]
,[refundamt] as [refundamt]
,[status] as [status]
into RawData_Cancels
from RawData_Cancels_Priorto2020

union all

--In the cancel redux data there are cancels with refund_amt > 0 and still date_proc field is null (0000-000...)
--so using the date_entered field for the cancel date
select
cast([date_entered] as date) as [date]
,[cust_id] as [custid]
,[accttype] as [accttype]
,[refund_amt] as [refundamt]
,[refund_status] as [status]
from Rawdata_cancel_redux

--Gets rid of duplicates, cancels after valdate

select cast([date] as date) as 'GPWCancelDate',
	custid, accttype, sum(refundamt) as 'RefundAmt'
into Cancels
from RawData_Cancels
where [date] <= @valdate
group by cast([date] as date), custid, accttype



IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'CancelsbyContract')
	DROP TABLE CancelsbyContract

--set up table
select GPWCancelDate,
	custid,
	accttype,
	coalesce(RefundAmt,0) as RefundAmt,
	cast(null as date) as [GPWEffectiveDate],
	cast(null as date) as [GPWExpireDate]

into CancelsbyContract
from Cancels

--1.  cancellation match between sales date and next sales date (if exists)
Update CancelsbyContract
Set GPWEffectiveDate = con.GPWEffectiveDate, GPWExpireDate = con.GPWExpireDate
from CancelsbyContract can left join contracts con 
	on can.custid=con.cust and can.accttype = con.GPWContractType and can.GPWCancelDate between con.[Sale Date] and case when con.Renew_SaleDate is null then con.GPWExpireDate else con.Renew_SaleDate end
where can.GPWEffectiveDate is null and can.accttype='Yearly'

--2.  cancellation match if there is only one contract record (Yearly)

Update CancelsbyContract
Set GPWEffectiveDate = con.GPWEffectiveDate, GPWExpireDate = con.GPWExpireDate
from CancelsbyContract can left join contracts con 
	on can.custid=con.cust and can.accttype = con.GPWContractType
where can.GPWEffectiveDate is null and can.accttype='Yearly' and con.CustidCount = 1


--3.  cancellation comes within contract dates
Update CancelsbyContract
Set GPWEffectiveDate = con.GPWEffectiveDate, GPWExpireDate = con.GPWExpireDate
from CancelsbyContract can left join contracts con
	on can.custid=con.cust and can.accttype = con.GPWContractType and can.GPWCancelDate between con.GPWEffectiveDate and con.GPWExpireDate
where can.[GPWEffectiveDate] is null and can.accttype='Yearly'


--3.  MONTHLY cancellation comes within contract dates
Update CancelsbyContract
Set GPWEffectiveDate = con.GPWEffectiveDate, GPWExpireDate = con.GPWExpireDate
from CancelsbyContract can left join contracts con
	on can.custid=con.cust and can.accttype = con.GPWContractType and can.GPWCancelDate between con.[GPWEffectiveDate] and con.[GPWExpireDate]
where can.[GPWEffectiveDate] is null and can.accttype='Monthly'
and con.[Source] = 'monthly_pre2021' --AJD 12/31/21 only using cancel info for older contracts


--4.  MONTHLY cancellation matched to last monthly record
Update CancelsbyContract
Set GPWEffectiveDate = con.GPWEffectiveDate, GPWExpireDate = con.GPWExpireDate
from CancelsbyContract can left join contracts con 
	on can.custid=con.cust and can.accttype = con.GPWContractType
where can.GPWEffectiveDate is null and can.accttype='Monthly' and con.MonthCount=con.Months
and con.[Source] = 'monthly_pre2021' --AJD 12/31/21 only using cancel info for older contracts

--5.  MONTHLY cancellation matched to zero month record (if exists)
Update CancelsbyContract
Set GPWEffectiveDate = con.GPWEffectiveDate, GPWExpireDate = con.GPWExpireDate
from CancelsbyContract can left join contracts con 
	on can.custid=con.cust and can.accttype = con.GPWContractType
where can.GPWEffectiveDate is null and can.accttype='Monthly' and con.Months=0
and con.[Source] = 'monthly_pre2021' --AJD 12/31/21 only using cancel info for older contracts


IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'CancelSummary')
	DROP TABLE CancelSummary

select max(GPWCancelDate) as GPWMaxCancelDate, custid, accttype, sum(refundamt) as refundamt, GPWEffectiveDate, GPWExpireDate
into CancelSummary
from CancelsbyContract
group by custid, accttype, GPWEffectiveDate, gpwexpiredate
GO
