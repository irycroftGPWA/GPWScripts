USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_0006_ProgramsUpdate]    Script Date: 5/16/2023 9:50:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_0006_ProgramsUpdate] AS


UPDATE ProgramsUnique
SET Program = 

CASE 
	WHEN [Insurance_Carrier] = 'SNW' THEN 'MLA'
          	WHEN [Insurance_Carrier] = 'RRG' OR [Insurance_Carrier] = 'RRGN' or [Insurance_Carrier] = 'RRGS' THEN 'SNV'			
	ELSE Program
END


UPDATE ProgramsUnique
SET Program = [Insurance_Carrier]
WHERE [Insurance_Carrier] = 'DOWC' 
or [Insurance_Carrier] = 'DOWH' 
--or [Insurance_Carrier] = 'DTWH'
OR [Insurance_Carrier] = 'DWPM' 
OR [Insurance_Carrier] = 'DWTW' 
OR [Insurance_Carrier] = 'MTL' 
OR [Insurance_Carrier] = 'RSTR' 


UPDATE ProgramsUnique
SET Program = 'JWTW'
WHERE [Insurance_Carrier] = 'JWTW' OR [Insurance_Carrier] = 'JWT2' 
GO
