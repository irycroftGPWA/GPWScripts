USE [36143_Sentruity_202212]
GO
/****** Object:  StoredProcedure [dbo].[sp_13_UPDATE_GPWContractData]    Script Date: 5/16/2023 11:04:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_13_UPDATE_GPWContractData] AS
UPDATE GPWContractData
SET GPWCancelCount1 = (Case	
			When GPWRelativeCancelQtr = 1  
			Then GPWCancelCount Else 0 
		    End), 
    GPWCancelCount2 = (Case 
			When GPWRelativeCancelQtr = 2  
			Then GPWCancelCount Else 0 
 	            End),
    GPWCancelCount3 = (Case 
			When GPWRelativeCancelQtr = 3  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount4 = (Case 
			When GPWRelativeCancelQtr = 4  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount5 = (Case 
			When GPWRelativeCancelQtr = 5  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount6 = (Case 
			When GPWRelativeCancelQtr = 6  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount7 = (Case 
			When GPWRelativeCancelQtr = 7  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount8 = (Case 
			When GPWRelativeCancelQtr = 8  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount9 = (Case 
			When GPWRelativeCancelQtr = 9  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount10 = (Case 
			When GPWRelativeCancelQtr = 10  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount11 = (Case 
			When GPWRelativeCancelQtr = 11  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount12 = (Case 
			When GPWRelativeCancelQtr = 12  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount13 = (Case 
			When GPWRelativeCancelQtr = 13  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount14 = (Case 
			When GPWRelativeCancelQtr = 14  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount15 = (Case 
			When GPWRelativeCancelQtr = 15  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount16 = (Case 
			When GPWRelativeCancelQtr = 16  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount17 = (Case 
			When GPWRelativeCancelQtr = 17  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount18 = (Case 
			When GPWRelativeCancelQtr = 18  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount19 = (Case 
			When GPWRelativeCancelQtr = 19  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount20 = (Case 
			When GPWRelativeCancelQtr = 20  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount21 = (Case 
			When GPWRelativeCancelQtr = 21  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount22 = (Case 
			When GPWRelativeCancelQtr = 22  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount23 = (Case
			When GPWRelativeCancelQtr = 23  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount24 = (Case
			When GPWRelativeCancelQtr = 24  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount25 = (Case
			When GPWRelativeCancelQtr = 25  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount26 = (Case
			When GPWRelativeCancelQtr = 26  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount27 = (Case
			When GPWRelativeCancelQtr = 27  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount28 = (Case
			When GPWRelativeCancelQtr = 28  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount29 = (Case
			When GPWRelativeCancelQtr = 29  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount30 = (Case
			When GPWRelativeCancelQtr = 30  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount31 = (Case
			When GPWRelativeCancelQtr = 31  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount32 = (Case
			When GPWRelativeCancelQtr = 32  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount33 = (Case
			When GPWRelativeCancelQtr = 33  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount34 = (Case
			When GPWRelativeCancelQtr = 34  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount35 = (Case
			When GPWRelativeCancelQtr = 35  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount36 = (Case
			When GPWRelativeCancelQtr = 36  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount37 = (Case
			When GPWRelativeCancelQtr = 37  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount38 = (Case
			When GPWRelativeCancelQtr = 38  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount39 = (Case
			When GPWRelativeCancelQtr = 39  
			Then GPWCancelCount Else 0 
 	            End),
     GPWCancelCount40 = (Case
			When GPWRelativeCancelQtr = 40  
			Then GPWCancelCount Else 0 
 	            End)
UPDATE GPWContractData			
SET GPWCancelRx1 = (Case			
			When GPWRelativeCancelQtr = 1  
			Then GPWCancelReserve Else 0 
		    End), 	
    GPWCancelRx2 = (Case 			
			When GPWRelativeCancelQtr = 2  
			Then GPWCancelReserve Else 0 
 	            End),		
    GPWCancelRx3 = (Case 			
			When GPWRelativeCancelQtr = 3  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx4 = (Case 			
			When GPWRelativeCancelQtr = 4  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx5 = (Case 			
			When GPWRelativeCancelQtr = 5  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx6 = (Case 			
			When GPWRelativeCancelQtr = 6  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx7 = (Case 			
			When GPWRelativeCancelQtr = 7  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx8 = (Case 			
			When GPWRelativeCancelQtr = 8  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx9 = (Case 			
			When GPWRelativeCancelQtr = 9  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx10 = (Case 			
			When GPWRelativeCancelQtr = 10  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx11 = (Case 			
			When GPWRelativeCancelQtr = 11  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx12 = (Case 			
			When GPWRelativeCancelQtr = 12  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx13 = (Case 			
			When GPWRelativeCancelQtr = 13  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx14 = (Case 			
			When GPWRelativeCancelQtr = 14  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx15 = (Case 			
			When GPWRelativeCancelQtr = 15  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx16 = (Case 			
			When GPWRelativeCancelQtr = 16  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx17 = (Case 			
			When GPWRelativeCancelQtr = 17  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx18 = (Case 			
			When GPWRelativeCancelQtr = 18  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx19 = (Case 			
			When GPWRelativeCancelQtr = 19  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx20 = (Case 			
			When GPWRelativeCancelQtr = 20  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx21 = (Case 			
			When GPWRelativeCancelQtr = 21  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx22 = (Case 			
			When GPWRelativeCancelQtr = 22  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx23 = (Case			
			When GPWRelativeCancelQtr = 23  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx24 = (Case			
			When GPWRelativeCancelQtr = 24  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx25 = (Case			
			When GPWRelativeCancelQtr = 25  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx26 = (Case			
			When GPWRelativeCancelQtr = 26  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx27 = (Case			
			When GPWRelativeCancelQtr = 27  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx28 = (Case			
			When GPWRelativeCancelQtr = 28  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx29 = (Case			
			When GPWRelativeCancelQtr = 29  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx30 = (Case			
			When GPWRelativeCancelQtr = 30  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx31 = (Case			
			When GPWRelativeCancelQtr = 31  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx32 = (Case			
			When GPWRelativeCancelQtr = 32  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx33 = (Case			
			When GPWRelativeCancelQtr = 33  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx34 = (Case			
			When GPWRelativeCancelQtr = 34  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx35 = (Case			
			When GPWRelativeCancelQtr = 35  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx36 = (Case			
			When GPWRelativeCancelQtr = 36  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx37 = (Case			
			When GPWRelativeCancelQtr = 37  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx38 = (Case			
			When GPWRelativeCancelQtr = 38  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx39 = (Case			
			When GPWRelativeCancelQtr = 39  
			Then GPWCancelReserve Else 0 
 	            End),		
     GPWCancelRx40 = (Case			
			When GPWRelativeCancelQtr = 40  
			Then GPWCancelReserve Else 0 
 	            End)		



GO
