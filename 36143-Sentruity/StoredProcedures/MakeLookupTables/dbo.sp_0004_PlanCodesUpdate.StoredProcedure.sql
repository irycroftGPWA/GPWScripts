USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_0004_PlanCodesUpdate]    Script Date: 5/16/2023 9:50:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[sp_0004_PlanCodesUpdate] AS

UPDATE PlanCodes
SET PlanCodes.Program = ProgramsToFillInPlanCodes.Program
FROM  PlanCodes INNER JOIN ProgramsToFillInPlanCodes ON 
PlanCodes.New_Used = ProgramsToFillInPlanCodes.New_Used AND 
PlanCodes.Rate_Book = ProgramsToFillInPlanCodes.Rate_Book AND 
PlanCodes.Plan_Code = ProgramsToFillInPlanCodes.Plan_Code AND 
PlanCodes.Plan_Description = ProgramsToFillInPlanCodes.Plan_Description
WHERE PlanCodes.Program is null

--updates for 12/2022

update PlanCodes
set Plan_Code = ''
where PlanCodes.Plan_Code = 'NA'

--A couple of missing plan_codes for 12_2022

insert into PlanCodes
select 
'68'
,'N'
,'T7'
,'TEC - GOLD PLAN (TGG - GROUP 1)'
,'Effective Date is the Sales Date                  '
,'Effective Odometer is Zero Miles'
,'TECTGG'

insert into PlanCodes
select 
'75'
,'U'
,'S3'
,'SECURENET PREMIER (MIG)'
,'Effective Date is the Manufacturer Warranty Start'
,'Effective Odometer is Zero Miles'
,'SNV'
GO
