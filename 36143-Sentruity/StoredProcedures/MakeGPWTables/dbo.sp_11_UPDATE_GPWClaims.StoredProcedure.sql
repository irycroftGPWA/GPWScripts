USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_11_UPDATE_GPWClaims]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_11_UPDATE_GPWClaims] AS
UPDATE GPWClaims 
SET GPWRelativeClaimQtr = Case 
	WHEN [GPWEffectiveQtr#] IS Null OR [GPWClaimQtr#] IS NULL
	THEN 0
	WHEN [GPWEffectiveQtr#] IS Not Null AND [GPWClaimQtr#] IS not NULL
	THEN [GPWClaimQtr#]-[GPWEffectiveQtr#]+1
	 End
FROM GPWClaims
UPDATE GPWClaims 
SET GPWActiveClaims = Case
	WHEN [GPWActiveClaimCount]=0
	THEN 0
	WHEN [GPWActiveClaimCount]<>0
	THEN [GPWClaims]
	 End
FROM GPWClaims
UPDATE GPWClaims 
SET GPWCancelClaims = Case
	WHEN [GPWCancelClaimCount]=0
	THEN 0
	WHEN [GPWCancelClaimCount]<>0
	THEN [GPWClaims]
	 End
FROM GPWClaims






IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GPWClaimsByContract')
	DROP TABLE GPWClaimsByContract

SELECT [Contract_Id], SUM(GPWClaims) AS GPWClaims, SUM(GPWClaimCount) AS GPWClaimCount
into GPWClaimsByContract
FROM GPWClaims
GROUP BY [Contract_Id]


UPDATE GPWContracts
SET GPWClaimCount = GPWClaimsByContract.GPWClaimCount
FROM GPWContracts INNER JOIN GPWClaimsByContract ON 
GPWContracts.[Contract_Id] = dbo.GPWClaimsByContract.[Contract_Id]

UPDATE GPWContracts
SET GPWClaims = GPWClaimsByContract.GPWClaims
FROM GPWContracts INNER JOIN GPWClaimsByContract ON 
GPWContracts.[Contract_Id] = GPWClaimsByContract.[Contract_Id]



IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GPWClaimsHarveyFlood')
	DROP TABLE GPWClaimsHarveyFlood

SELECT dbo.GPWClaims.*
into GPWClaimsHarveyFlood
FROM     dbo.GPWClaims LEFT OUTER JOIN
                  dbo.[GAP_Claim_Descriptions_Summed_12_2022] ON dbo.GPWClaims.Insurance_Carrier = dbo.[GAP_Claim_Descriptions_Summed_12_2022].[Carrier Abr]   
                  AND dbo.GPWClaims.Claim_Number = dbo.[GAP_Claim_Descriptions_Summed_12_2022].[Claim No] AND 
                  dbo.GPWClaims.Contract_Id = dbo.[GAP_Claim_Descriptions_Summed_12_2022].[Contract ID]
WHERE  (dbo.GPWClaims.Date_Loss_Occurred > CONVERT(DATETIME, '2017-08-24 00:00:00', 102) AND dbo.GPWClaims.Date_Loss_Occurred < CONVERT(DATETIME, '2017-09-05 00:00:00', 102)) AND 
                  (dbo.[GAP_Claim_Descriptions_Summed_12_2022].[Loss Cause Desc] = N'GAP Buyout - Flood')


--ALTER TABLE GPWContracts                 
--Add 
--GPWClaimCountHarvey float NULL



UPDATE GPWContracts
SET GPWClaimCountHarvey = coalesce(GPWClaimsHarveyFlood.GPWClaimCount,0)
FROM     dbo.GPWClaimsHarveyFlood INNER JOIN
                  dbo.GPWContracts ON dbo.GPWClaimsHarveyFlood.Contract_Id = dbo.GPWContracts.Contract_Id


IF EXISTS (SELECT name FROM sysobjects
	WHERE name = 'GPWClaimsImeldaFlood')
	DROP TABLE GPWClaimsImeldaFlood

SELECT dbo.GPWClaims.*
into GPWClaimsImeldaFlood
FROM     dbo.GPWClaims LEFT OUTER JOIN
                  dbo.[GAP_Claim_Descriptions_Summed_12_2022] ON dbo.GPWClaims.Insurance_Carrier = dbo.[GAP_Claim_Descriptions_Summed_12_2022].[Carrier Abr]   
                  AND dbo.GPWClaims.Claim_Number = dbo.[GAP_Claim_Descriptions_Summed_12_2022].[Claim No] AND 
                  dbo.GPWClaims.Contract_Id = dbo.[GAP_Claim_Descriptions_Summed_12_2022].[Contract ID]
WHERE  (dbo.GPWClaims.Date_Loss_Occurred > CONVERT(DATETIME, '2019-09-17 00:00:00', 102) AND dbo.GPWClaims.Date_Loss_Occurred < CONVERT(DATETIME, '2019-09-21 00:00:00', 102)) AND 
                  (dbo.[GAP_Claim_Descriptions_Summed_12_2022].[Loss Cause Desc] = N'GAP Buyout - Flood')


GO
