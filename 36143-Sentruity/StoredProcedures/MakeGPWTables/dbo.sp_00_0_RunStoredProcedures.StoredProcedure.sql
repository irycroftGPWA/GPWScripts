USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_00_0_RunStoredProcedures]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_00_0_RunStoredProcedures] AS

EXEC [sp_00_a_MAKE_Claims] 
EXEC [sp_00_b_MAKE_ClaimsSummed] 
--Test comment for commit
EXEC [sp_00_c_Make_GSFSContract_Detail]
EXEC [sp_00_d_UPDATE_GSFSContract_Detail]
EXEC [sp_00_e_MAKE_SentruityContractSplit2022]
EXEC [sp_01_MAKE_GPWContracts] 
EXEC [sp_02_UPDATE_GPWContracts] 
EXEC [sp_03_UPDATE_GPWContracts] 
EXEC [sp_04_UPDATE_GPWContracts] 
EXEC [sp_05_UPDATE_GPWContracts] 
EXEC [sp_06_UPDATE_GPWContracts] 
EXEC [sp_08_MAKE_GPWClaims] 
EXEC [sp_09_UPDATE_GPWClaims] 
EXEC [sp_10_UPDATE_GPWClaims] 
EXEC [sp_11_UPDATE_GPWClaims] 
EXEC [sp_07_MAKE_GPWContractData] 
EXEC [sp_12_MAKE_GPWClaimsData] 
EXEC [sp_13_UPDATE_GPWContractData] 
EXEC [sp_14_UPDATE_GPWClaimsData] 
EXEC [sp_15_MAKE_GPWContractDataSummaries] 
EXEC [sp_16_MAKE_GPWClaimsDataSummary] 
EXEC [sp_17_MAKE_GPWDataSummaries] 
EXEC [sp_18_MAKE_GPWContractsLookupFor2023]
GO
