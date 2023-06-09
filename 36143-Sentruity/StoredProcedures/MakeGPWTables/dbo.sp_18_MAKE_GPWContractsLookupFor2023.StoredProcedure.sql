USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_18_MAKE_GPWContractsLookupFor2023]    Script Date: 5/16/2023 11:04:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_18_MAKE_GPWContractsLookupFor2023] AS
IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GPWContractsLookupFor2023')
	DROP TABLE GPWContractsLookupFor2023
	
SELECT Contract_Id, Insurance_Carrier, Contract_Number, Sale_Odometer, GPWPlanID, PlanGroup, GPWCoverage, GPWObligor, GPWSentruityInsured, GPWState, GPWReinsurer, 
                      GPWDealer, GPWContractCount, GPWNetReserves, GPWEarnedReserves, GPWUnearnedReserves, GPWSentruityNetPrem, GPWSentruityEarnedPrem, 
                      GPWSentruityUnearnedPrem, GPWClaimCount, GPWClaims
into GPWContractsLookupFor2023
FROM         dbo.GPWContracts
GO
