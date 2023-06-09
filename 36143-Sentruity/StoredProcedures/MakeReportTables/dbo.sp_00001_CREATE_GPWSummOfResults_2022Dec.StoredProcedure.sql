USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_00001_CREATE_GPWSummOfResults_2022Dec]    Script Date: 5/16/2023 9:50:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sp_00001_CREATE_GPWSummOfResults_2022Dec] as

--******************************* 
--this procedure has been modified to bring in 2008, 2009 and 2010 results.  In 2011, we will be able to combine 2011 and the combined 2008-2010 tables to create the new summofresults table
--******************************* 

-------------------------------
----Removes unnecessary rows
--IF EXISTS (SELECT name FROM sysobjects
--	WHERE name = 'Temp')
--	DROP TABLE Temp

--Select *
--Into Temp
--From GPWExpToSQL_2020Dec
--Where [Contract Count]<>0

--IF EXISTS (SELECT name FROM sysobjects
--	WHERE name = 'GPWExpToSQL_2020Dec')
--	DROP TABLE GPWExpToSQL_2020Dec

--Select *
--Into GPWExpToSQL_2020Dec
--From Temp

---------------------------------
--Bringing in the 2021 Retained GAP with reserve adjustment





IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GPWSummOfResults_2022Dec')
	DROP TABLE GPWSummOfResults_2022Dec

;with ExpToSQLExcludingGAP as (
select *
from [36143_Sentruity_202112_NewCarriers].dbo.GPWSummOfResults_2021Dec
where case when SQLExportKEY1 = 'FD'
and SQLExportKEY2 = 'GWGS'
and SQLExportKEY3 = 'Dec_21'
and SQLExportKEY4 = 'Retained'
and SQLExportKEY5 = 'ALL' then 1 else 0 end = 0)

Select
'@12/31/22' as [ValYYYY_MM],
[SQLExportKEY1],
[SQLExportKEY2],
[SQLExportKEY3],
[SQLExportKEY4],
[SQLExportKEY5],
CASE WHEN [N/U/P] = 'Seg1_' THEN 'N' WHEN [N/U/P] = 'Seg2_' THEN 'U' ELSE 'P' END AS [N/U/P],
[Term Months],
[Effective Quarter],
left([Effective Quarter],4) as [Effective Year],
cast([Contract Count] as money) as [Contract Count],
cast([Cancel Count] as money) as [Cancel Count],
cast([Active Rx] as money) as [Active Rx],
cast([Cancel Rx] as money) as [Cancel Rx],
cast([Active Claim Count] as money) as [Active Claim Count],
cast([Cancel Claim Count] as money) as [Cancel Claim Count],
cast([Claim Count] as money) as [Claim Count],
cast([Active Claims] as money) as [Active Claims],
cast([Cancel Claims] as money) as [Cancel Claims],
cast([Claims] as money) as [Claims],
[SheetID],
case when [SelUltimate] ='NA'
	then 0
	when [SelUltimate] = '#N/A'
	then 0
	else CAST(cast([SelUltimate] as float) as money)
end as [SelUltimate],
case when [LDFUltimate] ='NA'
	then 0
	when [LDFUltimate] = '#N/A'
	then 0
	else cast(cast([LDFUltimate] as float) as money)
end as [LDFUltimate],
case when [BFUltimate] ='NA'
	then 0
	when [BFUltimate] = '#N/A'
	then 0
	else cast(cast([BFUltimate] as float) as money)
end as [BFUltimate],
case when [FSUltimate] ='NA'
	then 0
	when [FSUltimate] = '#N/A'
	then 0
	else cast(cast([FSUltimate] as float) as money)
end as [FSUltimate],
case when [AprioriLR] ='NA'
	then 0
	when [AprioriLR] = '#N/A'
	then 0
	else cast(cast([AprioriLR] as float) as money)
end as [AprioriLR],
case when [EarnedRx] ='NA'
	then 0
	when [EarnedRx] = '#N/A'
	then 0
	else cast(cast([EarnedRx] as float) as money)
end as [EarnedRx],
case when [UltimateNetRx] ='NA'
	then 0
	when [UltimateNetRx] = '#N/A'
	then 0
	else cast(cast([UltimateNetRx] as float) as money)
end as [UltimateNetRx],
case when [ProjFutureRefunds] ='NA'
	then 0
	when [ProjFutureRefunds] = '#N/A'
	then 0
	else cast(cast([ProjFutureRefunds] as float) as float)
end as [ProjFutureRefunds],
case when [PVofProjFutureRefunds] ='NA'
	then 0
	when [PVofProjFutureRefunds] = '#N/A'
	then 0
	else cast(cast([PVofProjFutureRefunds] as float) as float)
end as [PVofProjFutureRefunds],
case when [SelProjFutureLoss] ='NA'
	then 0
	when [SelProjFutureLoss] = '#N/A'
	then 0
	else cast(cast([SelProjFutureLoss] as float) as money)
end as [SelProjFutureLoss],
case when [PVofSelProjFutureLoss] ='NA'
	then 0
	when [PVofSelProjFutureLoss] = '#N/A'
	then 0
	else cast(cast([PVofSelProjFutureLoss] as float) as money)
end as [PVofSelProjFutureLoss],
[SQLExportKEY1] + '.' + [SQLExportKEY2] as [GPWCoverage]
INTO [GPWSummOfResults_2022Dec]
from [GPWExpToSQL_2022Dec]
where [Contract Count] <> 0 and SQLExportKEY1 <> 'AGGREGATE'

UNION ALL

--Everything from 2021 except for the gwgs retained. in 2023 the where clause can be removed
Select *
from ExpToSQLExcludingGAP

union all
--Bringing in the 2021 Retained GAP with reserve adjustment. Can be removed in 2023

Select
'@12/31/21' as [ValYYYY_MM],
[SQLExportKEY1],
[SQLExportKEY2],
[SQLExportKEY3],
[SQLExportKEY4],
[SQLExportKEY5],
CASE WHEN [N/U/P] = 'Seg1_' THEN 'N' WHEN [N/U/P] = 'Seg2_' THEN 'U' ELSE 'P' END AS [N/U/P],
[Term Months],
[Effective Quarter],
left([Effective Quarter],4) as [Effective Year],
cast([Contract Count] as money) as [Contract Count],
cast([Cancel Count] as money) as [Cancel Count],
cast([Active Rx] as money) as [Active Rx],
cast([Cancel Rx] as money) as [Cancel Rx],
cast([Active Claim Count] as money) as [Active Claim Count],
cast([Cancel Claim Count] as money) as [Cancel Claim Count],
cast([Claim Count] as money) as [Claim Count],
cast([Active Claims] as money) as [Active Claims],
cast([Cancel Claims] as money) as [Cancel Claims],
cast([Claims] as money) as [Claims],
[SheetID],
case when [SelUltimate] ='NA'
	then 0
	when [SelUltimate] = '#N/A'
	then 0
	else CAST(cast([SelUltimate] as float) as money)
end as [SelUltimate],
case when [LDFUltimate] ='NA'
	then 0
	when [LDFUltimate] = '#N/A'
	then 0
	else cast(cast([LDFUltimate] as float) as money)
end as [LDFUltimate],
case when [BFUltimate] ='NA'
	then 0
	when [BFUltimate] = '#N/A'
	then 0
	else cast(cast([BFUltimate] as float) as money)
end as [BFUltimate],
case when [FSUltimate] ='NA'
	then 0
	when [FSUltimate] = '#N/A'
	then 0
	else cast(cast([FSUltimate] as float) as money)
end as [FSUltimate],
case when [AprioriLR] ='NA'
	then 0
	when [AprioriLR] = '#N/A'
	then 0
	else cast(cast([AprioriLR] as float) as money)
end as [AprioriLR],
case when [EarnedRx] ='NA'
	then 0
	when [EarnedRx] = '#N/A'
	then 0
	else cast(cast([EarnedRx] as float) as money)
end as [EarnedRx],
case when [UltimateNetRx] ='NA'
	then 0
	when [UltimateNetRx] = '#N/A'
	then 0
	else cast(cast([UltimateNetRx] as float) as money)
end as [UltimateNetRx],
case when [ProjFutureRefunds] ='NA'
	then 0
	when [ProjFutureRefunds] = '#N/A'
	then 0
	else cast(cast([ProjFutureRefunds] as float) as float)
end as [ProjFutureRefunds],
case when [PVofProjFutureRefunds] ='NA'
	then 0
	when [PVofProjFutureRefunds] = '#N/A'
	then 0
	else cast(cast([PVofProjFutureRefunds] as float) as float)
end as [PVofProjFutureRefunds],
case when [SelProjFutureLoss] ='NA'
	then 0
	when [SelProjFutureLoss] = '#N/A'
	then 0
	else cast(cast([SelProjFutureLoss] as float) as money)
end as [SelProjFutureLoss],
case when [PVofSelProjFutureLoss] ='NA'
	then 0
	when [PVofSelProjFutureLoss] = '#N/A'
	then 0
	else cast(cast([PVofSelProjFutureLoss] as float) as money)
end as [PVofSelProjFutureLoss],
[SQLExportKEY1] + '.' + [SQLExportKEY2] as [GPWCoverage]
from [36143_Sentruity_202112_GAPReserveImpact].dbo.[GPWExpToSQL_2021DecGAPReserveAdjustment]
where [Contract Count] <> 0 and SQLExportKEY1 <> 'AGGREGATE'
GO
