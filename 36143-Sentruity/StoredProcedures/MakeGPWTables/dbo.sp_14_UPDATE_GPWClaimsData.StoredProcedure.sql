USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_14_UPDATE_GPWClaimsData]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_14_UPDATE_GPWClaimsData] AS
--      GPWClaimCount
UPDATE GPWClaimsData
SET
GPWClaimCount1 = (Case WHEN GPWRelativeClaimQtr <= 1 Then GPWClaimCount  
	Else 0 End), 
GPWClaimCount2 = (Case WHEN GPWRelativeClaimQtr <= 2 Then GPWClaimCount  
        Else 0 End), 
GPWClaimCount3 = (Case WHEN GPWRelativeClaimQtr <= 3 Then GPWClaimCount  
        Else 0 End), 
GPWClaimCount4 = (Case WHEN GPWRelativeClaimQtr <= 4 Then GPWClaimCount  
        Else 0 End),  
GPWClaimCount5 = (Case WHEN GPWRelativeClaimQtr <= 5 Then GPWClaimCount  
        Else 0 End), 
GPWClaimCount6 = (Case WHEN GPWRelativeClaimQtr <= 6 Then GPWClaimCount  
        Else 0 End),  
GPWClaimCount7 = (Case WHEN GPWRelativeClaimQtr <= 7 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount8 = (Case WHEN GPWRelativeClaimQtr <= 8 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount9 = (Case WHEN GPWRelativeClaimQtr <= 9 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount10 = (Case WHEN GPWRelativeClaimQtr <= 10 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount11 = (Case WHEN GPWRelativeClaimQtr <= 11 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount12 = (Case WHEN GPWRelativeClaimQtr <= 12 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount13 = (Case WHEN GPWRelativeClaimQtr <= 13 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount14 = (Case WHEN GPWRelativeClaimQtr <= 14 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount15 = (Case WHEN GPWRelativeClaimQtr <= 15 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount16 = (Case WHEN GPWRelativeClaimQtr <= 16 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount17 = (Case WHEN GPWRelativeClaimQtr <= 17 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount18 = (Case WHEN GPWRelativeClaimQtr <= 18 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount19 = (Case WHEN GPWRelativeClaimQtr <= 19 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount20 = (Case WHEN GPWRelativeClaimQtr <= 20 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount21 = (Case WHEN GPWRelativeClaimQtr <= 21 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount22 = (Case WHEN GPWRelativeClaimQtr <= 22 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount23 = (Case WHEN GPWRelativeClaimQtr <= 23 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount24 = (Case WHEN GPWRelativeClaimQtr <= 24 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount25 = (Case WHEN GPWRelativeClaimQtr <= 25 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount26 = (Case WHEN GPWRelativeClaimQtr <= 26 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount27 = (Case WHEN GPWRelativeClaimQtr <= 27 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount28 = (Case WHEN GPWRelativeClaimQtr <= 28 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount29 = (Case WHEN GPWRelativeClaimQtr <= 29 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount30 = (Case WHEN GPWRelativeClaimQtr <= 30 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount31 = (Case WHEN GPWRelativeClaimQtr <= 31 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount32 = (Case WHEN GPWRelativeClaimQtr <= 32 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount33 = (Case WHEN GPWRelativeClaimQtr <= 33 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount34 = (Case WHEN GPWRelativeClaimQtr <= 34 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount35 = (Case WHEN GPWRelativeClaimQtr <= 35 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount36 = (Case WHEN GPWRelativeClaimQtr <= 36 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount37 = (Case WHEN GPWRelativeClaimQtr <= 37 Then GPWClaimCount  
        Else 0 End),
GPWClaimCount38 = (Case WHEN GPWRelativeClaimQtr <= 38 Then GPWClaimCount 
        Else 0 End),
GPWClaimCount39 = (Case WHEN GPWRelativeClaimQtr <= 39 Then GPWClaimCount
        Else 0 End),
GPWClaimCount40 = (Case WHEN GPWRelativeClaimQtr <= 40 Then GPWClaimCount 
	Else 0 End)  
FROM GPWClaimsData
--      GPWclaims
UPDATE GPWClaimsData
SET
GPWClaims1    = (Case 	WHEN GPWRelativeClaimQtr <= 1 
			Then GPWClaims
        		Else 0 
		End),
GPWClaims2   =  (Case WHEN GPWRelativeClaimQtr <= 2 
			Then GPWClaims
        		Else 0 
		End),
GPWClaims3   =  (Case WHEN GPWRelativeClaimQtr <= 3 
			Then GPWClaims
        		Else 0 
		End),
GPWClaims4   =  (Case WHEN GPWRelativeClaimQtr <= 4 
			Then GPWClaims
        		Else 0 
		End),
GPWClaims5   =   (Case WHEN GPWRelativeClaimQtr <= 5 
			Then GPWClaims
        		Else 0 
		End),
GPWClaims6  =    (Case WHEN GPWRelativeClaimQtr <= 6 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims7   =   (Case WHEN GPWRelativeClaimQtr <= 7 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims8   =   (Case WHEN GPWRelativeClaimQtr <= 8 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims9  =    (Case WHEN GPWRelativeClaimQtr <= 9 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims10 =    (Case WHEN GPWRelativeClaimQtr <= 10 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims11 =    (Case WHEN GPWRelativeClaimQtr <= 11 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims12 =    (Case WHEN GPWRelativeClaimQtr <= 12 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims13 =    (Case WHEN GPWRelativeClaimQtr <= 13 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims14=    (Case 	WHEN GPWRelativeClaimQtr <= 14 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims15  =  (Case 	WHEN GPWRelativeClaimQtr <= 15 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims16  =  (Case 	WHEN GPWRelativeClaimQtr <= 16 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims17 =   (Case 	WHEN GPWRelativeClaimQtr <= 17 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims18 =   (Case 	WHEN GPWRelativeClaimQtr <= 18 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims19=    (Case 	WHEN GPWRelativeClaimQtr <= 19 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims20 =   (Case 	WHEN GPWRelativeClaimQtr <= 20 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims21 =   (Case 	WHEN GPWRelativeClaimQtr <= 21 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims22 =   (Case 	WHEN GPWRelativeClaimQtr <= 22 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims23 =   (Case 	WHEN GPWRelativeClaimQtr <= 23 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims24 =   (Case 	WHEN GPWRelativeClaimQtr <= 24 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims25  =  (Case 	WHEN GPWRelativeClaimQtr <= 25 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims26  =  (Case 	WHEN GPWRelativeClaimQtr <= 26 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims27  =  (Case 	WHEN GPWRelativeClaimQtr <= 27 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims28  =  (Case 	WHEN GPWRelativeClaimQtr <= 28 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims29   = (Case 	WHEN GPWRelativeClaimQtr <= 29 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims30  =  (Case 	WHEN GPWRelativeClaimQtr <= 30 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims31  =  (Case 	WHEN GPWRelativeClaimQtr <= 31 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims32  =  (Case 	WHEN GPWRelativeClaimQtr <= 32 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims33  =  (Case 	WHEN GPWRelativeClaimQtr <= 33 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims34  =  (Case 	WHEN GPWRelativeClaimQtr <= 34 
			Then GPWClaims
		        Else 0 
		End),	
GPWClaims35  =  (Case 	WHEN GPWRelativeClaimQtr <= 35 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims36 =   (Case 	WHEN GPWRelativeClaimQtr <= 36 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims37 =   (Case 	WHEN GPWRelativeClaimQtr <= 37 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims38 =   (Case 	WHEN GPWRelativeClaimQtr <= 38 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims39 =   (Case 	WHEN GPWRelativeClaimQtr <= 39 
			Then GPWClaims
		        Else 0 
		End),
GPWClaims40=    (Case 	WHEN GPWRelativeClaimQtr <= 40 
			Then GPWClaims
		        Else 0 End)
FROM GPWClaimsData



GO
