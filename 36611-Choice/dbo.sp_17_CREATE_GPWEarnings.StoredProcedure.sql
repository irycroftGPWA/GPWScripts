USE [36611_202212_ChoiceHW]
GO
/****** Object:  StoredProcedure [dbo].[sp_17_CREATE_GPWEarnings]    Script Date: 5/18/2023 8:24:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_17_CREATE_GPWEarnings] AS

DECLARE @ValDate as DATE

IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GPW_Earnings')
	DROP TABLE GPW_Earnings

select
[GPWRenewalFlag] as [GPWRenewalFlag]
,[GPWContractType] as [GPWContractType]
,[GPW N/U/P] as [GPW N/U/P]
,[GPWPlan] as [GPWPlan]
,GPWRelativeCancelQtr as GPWRelativeCancelQtr
,GPWContractCount as GPWContractCount 
,[GPWEffectiveDate] as [GPWEffectiveDate]
,[GPW Channel] as [GPW Channel]
,[GPWEarnTermMonths] as GPWEarnTermMonths
,[TermMonths] as [TermMonths]
,[GPWTermMonths] as [GPWTermMonths]
,[CancelRefund] as [CancelRefund]
,[GPWFlatCancel] as [GPWFlatCancel]
,[GPWCancelDate] as [GPWCancelDate]
,[GPWGrossReserve] as [GPWGrossReserve]
,[GPWUpFrontAdj] as [GPWUpFrontAdj]
,[GPWActiveReserve] as [GPWActiveReserve]
,[GPWCancelReserve] as [GPWCancelReserve]

,cast(NULL as int) as GPWLag_20171231
,cast(NULL as int) as GPWLag_20181231
,cast(NULL as int) as GPWLag_20191231
,cast(NULL as int) as GPWLag_20201231
,cast(NULL as int) as GPWLag_20211231

,cast(NULL as float) as GPWPercEarn_20171231
,cast(NULL as float) as GPWPercEarn_20181231
,cast(NULL as float) as GPWPercEarn_20191231
,cast(NULL as float) as GPWPercEarn_20201231
,cast(NULL as float) as GPWPercEarn_20211231

,cast(NULL as int) as GPWContractCount_20171231
,cast(NULL as int) as GPWContractCount_20181231
,cast(NULL as int) as GPWContractCount_20191231
,cast(NULL as int) as GPWContractCount_20201231
,cast(NULL as int) as GPWContractCount_20211231

,cast(NULL as int) as GPWCancelCount_20171231
,cast(NULL as int) as GPWCancelCount_20181231
,cast(NULL as int) as GPWCancelCount_20191231
,cast(NULL as int) as GPWCancelCount_20201231
,cast(NULL as int) as GPWCancelCount_20211231

,cast(NULL as float) as GPWActiveReserve_20171231
,cast(NULL as float) as GPWActiveReserve_20181231
,cast(NULL as float) as GPWActiveReserve_20191231
,cast(NULL as float) as GPWActiveReserve_20201231
,cast(NULL as float) as GPWActiveReserve_20211231

,cast(NULL as float) as GPWCancelReserve_20171231
,cast(NULL as float) as GPWCancelReserve_20181231
,cast(NULL as float) as GPWCancelReserve_20191231
,cast(NULL as float) as GPWCancelReserve_20201231
,cast(NULL as float) as GPWCancelReserve_20211231

,cast(NULL as float) as GPWEarnResStd_20171231
,cast(NULL as float) as GPWEarnResStd_20181231
,cast(NULL as float) as GPWEarnResStd_20191231
,cast(NULL as float) as GPWEarnResStd_20201231
,cast(NULL as float) as GPWEarnResStd_20211231

,cast(NULL as float) as GPWEarnResAdj_20171231
,cast(NULL as float) as GPWEarnResAdj_20181231
,cast(NULL as float) as GPWEarnResAdj_20191231
,cast(NULL as float) as GPWEarnResAdj_20201231
,cast(NULL as float) as GPWEarnResAdj_20211231

into GPW_Earnings
from GPWContracts

----**********UPDATE LAG

SET @ValDate = cast('12/31/2017' as date)
Update GPW_Earnings
Set GPWLag_20171231 = datediff(month,GPWEffectiveDate,@Valdate)+1
Update GPW_Earnings
Set GPWPercEarn_20171231 = case when c.GPWLag_20171231 > 75 then 1
						when c.GPWLag_20171231<=0 then 0
						when c.GPWEarnTermMonths = 1 and c.GPWLag_20171231=1 then 0.5
						when c.GPWEarnTermMonths = 1 then 1 else
						e.CumulPercEarned end
	from GPW_Earnings c left join tbl_EarningCurves e
		on c.[GPW Channel] = e.Channel
		and c.GPWLag_20171231=e.Lag
		and c.GPWEarnTermMonths = e.TermMonths


--**********UPDATE LAG

SET @ValDate = cast('12/31/2018' as date)
Update GPW_Earnings
Set GPWLag_20181231 = datediff(month,GPWEffectiveDate,@Valdate)+1
Update GPW_Earnings
Set GPWPercEarn_20181231 = case when c.GPWLag_20181231 > 75 then 1
						when c.GPWLag_20181231<=0 then 0
						when c.GPWEarnTermMonths = 1 and c.GPWLag_20181231=1 then 0.5
						when c.GPWEarnTermMonths = 1 then 1 else
						e.CumulPercEarned end
	from GPW_Earnings c left join tbl_EarningCurves e
		on c.[GPW Channel] = e.Channel
		and c.GPWLag_20181231=e.Lag
		and c.GPWEarnTermMonths = e.TermMonths
--**********UPDATE LAG

SET @ValDate = cast('12/31/2019' as date)
Update GPW_Earnings
Set GPWLag_20191231 = datediff(month,GPWEffectiveDate,@Valdate)+1
Update GPW_Earnings
Set GPWPercEarn_20191231 = case when c.GPWLag_20191231 > 75 then 1
						when c.GPWLag_20191231<=0 then 0
						when c.GPWEarnTermMonths = 1 and c.GPWLag_20191231=1 then 0.5
						when c.GPWEarnTermMonths = 1 then 1 else
						e.CumulPercEarned end
	from GPW_Earnings c left join tbl_EarningCurves e
		on c.[GPW Channel] = e.Channel
		and c.GPWLag_20191231=e.Lag
		and c.GPWEarnTermMonths = e.TermMonths
--**********UPDATE LAG

SET @ValDate = cast('12/31/2020' as date)
Update GPW_Earnings
Set GPWLag_20201231 = datediff(month,GPWEffectiveDate,@Valdate)+1
Update GPW_Earnings
Set GPWPercEarn_20201231 = case when c.GPWLag_20201231 > 75 then 1
						when c.GPWLag_20201231<=0 then 0
						when c.GPWEarnTermMonths = 1 and c.GPWLag_20201231=1 then 0.5
						when c.GPWEarnTermMonths = 1 then 1 else
						e.CumulPercEarned end
	from GPW_Earnings c left join tbl_EarningCurves e
		on c.[GPW Channel] = e.Channel
		and c.GPWLag_20201231=e.Lag
		and c.GPWEarnTermMonths = e.TermMonths


--**********UPDATE LAG

SET @ValDate = cast('12/31/2021' as date)
Update GPW_Earnings
Set GPWLag_20211231 = datediff(month,GPWEffectiveDate,@Valdate)+1
Update GPW_Earnings
Set GPWPercEarn_20211231 = case when c.GPWLag_20211231 > 75 then 1
						when c.GPWLag_20211231<=0 then 0
						when c.GPWEarnTermMonths = 1 and c.GPWLag_20211231=1 then 0.5
						when c.GPWEarnTermMonths = 1 then 1 else
						e.CumulPercEarned end
	from GPW_Earnings c left join tbl_EarningCurves e
		on c.[GPW Channel] = e.Channel
		and c.GPWLag_20211231=e.Lag
		and c.GPWEarnTermMonths = e.TermMonths
----=====================================================================================================

----****** UPDATE CONTRACT COUNT
Set @ValDate = cast('12/31/2017' as date)
UPDATE GPW_Earnings 
SET GPWContractCount_20171231 = 1 
UPDATE GPW_Earnings 
SET GPWContractCount_20171231 = 0
WHERE [GPWEffectiveDate]>@ValDate
	Or [GPWTermMonths]<1 Or [TermMonths]>180  --ACL: LW has 180
	Or [GPWFlatCancel]='F'

--******UPDATE CONTRACT COUNT
Set @ValDate = cast('12/31/2018' as date)
UPDATE GPW_Earnings 
SET GPWContractCount_20181231 = 1 
UPDATE GPW_Earnings 
SET GPWContractCount_20181231 = 0
WHERE [GPWEffectiveDate]>@ValDate
	Or [GPWTermMonths]<1 Or [TermMonths]>180  --ACL: LW has 180
	Or [GPWFlatCancel]='F'
--******UPDATE CONTRACT COUNT
Set @ValDate = cast('12/31/2019' as date)
UPDATE GPW_Earnings 
SET GPWContractCount_20191231 = 1 
UPDATE GPW_Earnings 
SET GPWContractCount_20191231 = 0
WHERE [GPWEffectiveDate]>@ValDate
	Or [GPWTermMonths]<1 Or [TermMonths]>180  --ACL: LW has 180
	Or [GPWFlatCancel]='F'
----******
--******UPDATE CONTRACT COUNT
Set @ValDate = cast('12/31/2020' as date)
UPDATE GPW_Earnings 
SET GPWContractCount_20201231 = 1 
UPDATE GPW_Earnings 
SET GPWContractCount_20201231 = 0
WHERE [GPWEffectiveDate]>@ValDate
	Or [GPWTermMonths]<1 Or [TermMonths]>180  --ACL: LW has 180
	Or [GPWFlatCancel]='F'
----******
--******UPDATE CONTRACT COUNT
Set @ValDate = cast('12/31/2021' as date)
UPDATE GPW_Earnings 
SET GPWContractCount_20211231 = 1 
UPDATE GPW_Earnings 
SET GPWContractCount_20211231 = 0
WHERE [GPWEffectiveDate]>@ValDate
	Or [GPWTermMonths]<1 Or [TermMonths]>180  --ACL: LW has 180
	Or [GPWFlatCancel]='F'
----******

----=====================================================================================================


----*****UPDATE CANCEL COUNT
SET @ValDate = cast('12/31/2017' as date)
UPDATE GPW_Earnings
SET GPWCancelCount_20171231= 0
WHERE GPWContractCount_20171231=0
UPDATE GPW_Earnings
Set GPWCancelCount_20171231 = 0
WHERE GPWCancelDate > @ValDate
UPDATE GPW_Earnings
SET GPWCancelCount_20171231 = 1
WHERE GPWCancelDate <= @ValDate AND GPWContractCount_20171231<>0

--*****UPDATE CANCEL COUNT
SET @ValDate = cast('12/31/2018' as date)
UPDATE GPW_Earnings
SET GPWCancelCount_20181231= 0
WHERE GPWContractCount_20181231=0
UPDATE GPW_Earnings
Set GPWCancelCount_20181231 = 0
WHERE GPWCancelDate > @ValDate
UPDATE GPW_Earnings
SET GPWCancelCount_20181231 = 1
WHERE GPWCancelDate <= @ValDate AND GPWContractCount_20181231<>0

--*****UPDATE CANCEL COUNT
SET @ValDate = cast('12/31/2019' as date)
UPDATE GPW_Earnings
SET GPWCancelCount_20191231= 0
WHERE GPWContractCount_20191231=0
UPDATE GPW_Earnings
Set GPWCancelCount_20191231 = 0
WHERE GPWCancelDate > @ValDate
UPDATE GPW_Earnings
SET GPWCancelCount_20191231 = 1
WHERE GPWCancelDate <= @ValDate AND GPWContractCount_20191231<>0

--*****UPDATE CANCEL COUNT
SET @ValDate = cast('12/31/2020' as date)
UPDATE GPW_Earnings
SET GPWCancelCount_20201231= 0
WHERE GPWContractCount_20201231=0
UPDATE GPW_Earnings
Set GPWCancelCount_20201231 = 0
WHERE GPWCancelDate > @ValDate
UPDATE GPW_Earnings
SET GPWCancelCount_20201231 = 1
WHERE GPWCancelDate <= @ValDate AND GPWContractCount_20201231<>0

--*****UPDATE CANCEL COUNT
SET @ValDate = cast('12/31/2021' as date)
UPDATE GPW_Earnings
SET GPWCancelCount_20211231= 0
WHERE GPWContractCount_20211231=0
UPDATE GPW_Earnings
Set GPWCancelCount_20211231 = 0
WHERE GPWCancelDate > @ValDate
UPDATE GPW_Earnings
SET GPWCancelCount_20211231 = 1
WHERE GPWCancelDate <= @ValDate AND GPWContractCount_20211231<>0
----*****
----*****
----=====================================================================================================

----***************UPDATE EARNED RX ADJUSTMENT
--2017 Quarterly
--*******************
UPDATE GPW_Earnings
SET GPWActiveReserve_20171231 = GPWGrossReserve
FROM GPW_Earnings
WHERE GPWContractCount_20171231 <> 0 AND (GPWCancelCount_20171231 <> 1 or GPWCancelCount_20171231 is null)
UPDATE GPW_Earnings
SET GPWActiveReserve_20171231 = 0
FROM GPW_Earnings
WHERE GPWContractCount_20171231 = 0 OR GPWCancelCount_20171231 = 1
UPDATE GPW_Earnings
SET GPWCancelReserve_20171231 = GPWGrossReserve - CancelRefund
FROM GPW_Earnings
WHERE GPWCancelCount_20171231=1
UPDATE GPW_Earnings
SET GPWCancelReserve_20171231 = 0
FROM GPW_Earnings
WHERE GPWCancelCount_20171231 <> 1 or GPWCancelCount_20171231 is null
Update GPW_Earnings
Set GPWEarnResStd_20171231 = GPWActiveReserve_20171231 * GPWPercEarn_20171231 + GPWCancelReserve_20171231
Update GPW_Earnings
Set GPWEarnResAdj_20171231 = case when GPWContractCount_20171231 <> 0 AND (GPWCancelCount_20171231 <> 1 or GPWCancelCount_20171231 is null)
									then case when GPWTermMonths = 1 then GPWActiveReserve_20171231 * GPWPercEarn_20171231
											when GPWActiveReserve_20171231 <= GPWUpFrontAdj  then GPWActiveReserve_20171231
											else (GPWActiveReserve_20171231 - GPWUpFrontAdj) * GPWPercEarn_20171231 + GPWUpFrontAdj end
									when GPWCancelCount_20171231=1
									then GPWCancelReserve_20171231 end

--*******************UPDATE EARNED RX ADJUSTMENT
UPDATE GPW_Earnings
SET GPWActiveReserve_20181231 = GPWGrossReserve
FROM GPW_Earnings
WHERE GPWContractCount_20181231 <> 0 AND (GPWCancelCount_20181231 <> 1 or GPWCancelCount_20181231 is null)
UPDATE GPW_Earnings
SET GPWActiveReserve_20181231 = 0
FROM GPW_Earnings
WHERE GPWContractCount_20181231 = 0 OR GPWCancelCount_20181231 = 1
UPDATE GPW_Earnings
SET GPWCancelReserve_20181231 = GPWGrossReserve - CancelRefund
FROM GPW_Earnings
WHERE GPWCancelCount_20181231=1
UPDATE GPW_Earnings
SET GPWCancelReserve_20181231 = 0
FROM GPW_Earnings
WHERE GPWCancelCount_20181231 <> 1 or GPWCancelCount_20181231 is null
Update GPW_Earnings
Set GPWEarnResStd_20181231 = GPWActiveReserve_20181231 * GPWPercEarn_20181231 + GPWCancelReserve_20181231
Update GPW_Earnings
Set GPWEarnResAdj_20181231 = case when GPWContractCount_20181231 <> 0 AND (GPWCancelCount_20181231 <> 1 or GPWCancelCount_20181231 is null)
 									then case when GPWTermMonths = 1 then GPWActiveReserve_20181231 * GPWPercEarn_20181231
											when GPWActiveReserve_20181231 <= GPWUpFrontAdj  then GPWActiveReserve_20181231
											else (GPWActiveReserve_20181231 - GPWUpFrontAdj) * GPWPercEarn_20181231 + GPWUpFrontAdj end
									when GPWCancelCount_20181231=1
									then GPWCancelReserve_20181231 end


--*******************UPDATE EARNED RX ADJUSTMENT
UPDATE GPW_Earnings
SET GPWActiveReserve_20191231 = GPWGrossReserve
FROM GPW_Earnings
WHERE GPWContractCount_20191231 <> 0 AND (GPWCancelCount_20191231 <> 1 or GPWCancelCount_20191231 is null)
UPDATE GPW_Earnings
SET GPWActiveReserve_20191231 = 0
FROM GPW_Earnings
WHERE GPWContractCount_20191231 = 0 OR GPWCancelCount_20191231 = 1
UPDATE GPW_Earnings
SET GPWCancelReserve_20191231 = GPWGrossReserve - CancelRefund
FROM GPW_Earnings
WHERE GPWCancelCount_20191231=1
UPDATE GPW_Earnings
SET GPWCancelReserve_20191231 = 0
FROM GPW_Earnings
WHERE GPWCancelCount_20191231 <> 1 or GPWCancelCount_20191231 is null
Update GPW_Earnings
Set GPWEarnResStd_20191231 = GPWActiveReserve_20191231 * GPWPercEarn_20191231 + GPWCancelReserve_20191231
Update GPW_Earnings
Set GPWEarnResAdj_20191231 = case when GPWContractCount_20191231 <> 0 AND (GPWCancelCount_20191231 <> 1 or GPWCancelCount_20191231 is null)
									then case when GPWTermMonths = 1 then GPWActiveReserve_20191231 * GPWPercEarn_20191231
											when GPWActiveReserve_20191231 <= GPWUpFrontAdj  then GPWActiveReserve_20191231
											else (GPWActiveReserve_20191231 - GPWUpFrontAdj) * GPWPercEarn_20191231 + GPWUpFrontAdj end
									when GPWCancelCount_20191231=1
									then GPWCancelReserve_20191231 end

--*******************UPDATE EARNED RX ADJUSTMENT
UPDATE GPW_Earnings
SET GPWActiveReserve_20201231 = GPWGrossReserve
FROM GPW_Earnings
WHERE GPWContractCount_20201231 <> 0 AND (GPWCancelCount_20201231 <> 1 or GPWCancelCount_20201231 is null)
UPDATE GPW_Earnings
SET GPWActiveReserve_20201231 = 0
FROM GPW_Earnings
WHERE GPWContractCount_20201231 = 0 OR GPWCancelCount_20201231 = 1
UPDATE GPW_Earnings
SET GPWCancelReserve_20201231 = GPWGrossReserve - CancelRefund
FROM GPW_Earnings
WHERE GPWCancelCount_20201231=1
UPDATE GPW_Earnings
SET GPWCancelReserve_20201231 = 0
FROM GPW_Earnings
WHERE GPWCancelCount_20201231 <> 1 or GPWCancelCount_20201231 is null
Update GPW_Earnings
Set GPWEarnResStd_20201231 = GPWActiveReserve_20201231 * GPWPercEarn_20201231 + GPWCancelReserve_20201231
Update GPW_Earnings
Set GPWEarnResAdj_20201231 = case when GPWContractCount_20201231 <> 0 AND (GPWCancelCount_20201231 <> 1 or GPWCancelCount_20201231 is null)
									then case when GPWTermMonths = 1 then GPWActiveReserve_20201231 * GPWPercEarn_20201231
											when GPWActiveReserve_20201231 <= GPWUpFrontAdj  then GPWActiveReserve_20201231
											else (GPWActiveReserve_20201231 - GPWUpFrontAdj) * GPWPercEarn_20201231 + GPWUpFrontAdj end
									when GPWCancelCount_20201231=1
									then GPWCancelReserve_20201231 end

--*******************UPDATE EARNED RX ADJUSTMENT
UPDATE GPW_Earnings
SET GPWActiveReserve_20211231 = GPWGrossReserve
FROM GPW_Earnings
WHERE GPWContractCount_20211231 <> 0 AND (GPWCancelCount_20211231 <> 1 or GPWCancelCount_20211231 is null)
UPDATE GPW_Earnings
SET GPWActiveReserve_20211231 = 0
FROM GPW_Earnings
WHERE GPWContractCount_20211231 = 0 OR GPWCancelCount_20211231 = 1
UPDATE GPW_Earnings
SET GPWCancelReserve_20211231 = GPWGrossReserve - CancelRefund
FROM GPW_Earnings
WHERE GPWCancelCount_20211231=1
UPDATE GPW_Earnings
SET GPWCancelReserve_20211231 = 0
FROM GPW_Earnings
WHERE GPWCancelCount_20211231 <> 1 or GPWCancelCount_20211231 is null
Update GPW_Earnings
Set GPWEarnResStd_20211231 = GPWActiveReserve_20211231 * GPWPercEarn_20211231 + GPWCancelReserve_20211231
Update GPW_Earnings
Set GPWEarnResAdj_20211231 = case when GPWContractCount_20211231 <> 0 AND (GPWCancelCount_20211231 <> 1 or GPWCancelCount_20211231 is null)
									then case when GPWTermMonths = 1 then GPWActiveReserve_20211231 * GPWPercEarn_20211231
											when GPWActiveReserve_20211231 <= GPWUpFrontAdj  then GPWActiveReserve_20211231
											else (GPWActiveReserve_20211231 - GPWUpFrontAdj) * GPWPercEarn_20211231 + GPWUpFrontAdj end
									when GPWCancelCount_20211231=1
									then GPWCancelReserve_20211231 end

----*******************
GO
