USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_05_UPDATE_GPWContracts]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_05_UPDATE_GPWContracts] AS
-- UPDATE GPWActiveReserve
UPDATE GPWContracts
SET GPWActiveReserve = 0
FROM GPWContracts
WHERE GPWContractCount = 0 OR GPWCancelCount=1
UPDATE GPWContracts
SET GPWActiveReserve = [Base_Claim_Reserve]+[Surcharge_Reserve]
FROM GPWContracts
WHERE GPWContractCount <> 0 AND GPWCancelCount<>1
-- UPDATE GPWCancelReserve
UPDATE GPWContracts
SET GPWCancelReserve = [Base_Claim_Reserve]+[Surcharge_Reserve]-[Refund_Reserve_Amount]
--SET GPWCancelReserve = [Claim_Reserve_Earned]
FROM GPWContracts
WHERE GPWCancelCount=1
UPDATE GPWContracts
SET GPWCancelReserve = 0
FROM GPWContracts
WHERE GPWCancelCount<>1  
-- UPDATE GPWRelativeCancelQtr
UPDATE GPWContracts
SET GPWRelativeCancelQtr = 0
FROM GPWContracts
WHERE [GPWEffectiveQtr#]=0 OR [GPWCancelQtr#] =0
UPDATE GPWContracts
SET GPWRelativeCancelQtr = [GPWCancelQtr#]-[GPWEffectiveQtr#]+1
FROM GPWContracts
WHERE  ([GPWEffectiveQtr#]) <>0 AND [GPWCancelQtr#]<>0
UPDATE GPWContracts
SET GPWCoverage = 
case when GPWDealer = '42266' and Insurance_Carrier = 'DWTW'  --added these two conditions 2/18/2016; jerry's warrant has its own triangle and these dwtw contracts need to be moved there - not in the DOWC PORC analysis
	THEN 'JWTW_JWTW'
	when GPWDealer = '42303' and Insurance_Carrier = 'DWTW'   --added these two conditions 2/18/2016; jerry's warrant has its own triangle and these dwtw contracts need to be moved there - not in the DOWC PORC analysis
	THEN 'JWTW_JWTW'
	else [Insurance_Carrier]+'_'+[PlanGroup]
	end
FROM GPWContracts



GO
