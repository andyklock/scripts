SELECT /* BDH414 RADEV-colo */ SUM(B.AMOUNT) 
FROM cirrogt.CONTR_SERV_PNT_RECVBL A, cirrogt.CALC_RATE_ON_USG B, cirrogt.BILLED_USAGE C, cirrogt.CONTRACT_SERVICE_POINT D 
WHERE A.BILL_DATE >= TO_DATE('01/05/2010', 'mm/dd/yyyy') 
AND A.BILL_DATE < TO_DATE('01/06/2010', 'mm/dd/yyyy') 
AND A.RECVBL_STATUS_CD = 2 
AND B.BILL_CYCLE_RUN_ID = A.BILL_CYCLE_RUN_ID 
AND B.CONTRACT_SERVICE_POINT_ID = A.CONTRACT_SERVICE_POINT_ID 
AND B.CALC_RATE_STATUS_CD = 2 
AND B.TAX_CODE = 'U' 
AND C.BILLED_USAGE_ID = B.BILLED_USAGE_ID 
AND C.BILLED_USAGE_STATUS = 7 
AND D.CONTRACT_SERVICE_POINT_ID = C.CONTRACT_SERVICE_POINT_ID 
AND D.OFFERING_ID = 42
