USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_00_d_UPDATE_GSFSContract_Detail]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_00_d_UPDATE_GSFSContract_Detail] AS



UPDATE GSFSContract_Detail
SET GSFSContract_Detail.sIssue_State = dbo.GPWContractsLookupFor2021.GPWState
FROM         dbo.GSFSContract_Detail INNER JOIN
                      dbo.GPWContractsLookupFor2021 ON dbo.GSFSContract_Detail.Contract_Number = dbo.GPWContractsLookupFor2021.Contract_Number
WHERE  (GSFSContract_Detail.sIssue_State IS NULL or GSFSContract_Detail.sIssue_State = '')


UPDATE GSFSContract_Detail
SET GSFSContract_Detail.Sale_Odometer = dbo.GPWContractsLookupFor2021.Sale_Odometer
FROM         dbo.GSFSContract_Detail INNER JOIN
                      dbo.GPWContractsLookupFor2021 ON dbo.GSFSContract_Detail.Contract_Number = dbo.GPWContractsLookupFor2021.Contract_Number
WHERE  (GSFSContract_Detail.Sale_Odometer != dbo.GPWContractsLookupFor2021.Sale_Odometer and year(GSFSContract_Detail.Contract_Sale_Date) < 2012)
GO
