DECLARE v_count NUMBER;
BEGIN

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'KEYWORDS';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'DROP TABLE KEYWORDS';
END IF;

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'ADVERTISERS';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'DROP TABLE ADVERTISERS';
END IF;

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'QUERIES';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'DROP TABLE QUERIES';
END IF;

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'BIDSG2';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table BIDSG2';
END IF;

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'BIDSB2';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table BIDSB2';
END IF;

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'BIDSGB2';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table BIDSGB2';
END IF;

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'ADVERTISERREMBAL';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table AdvertiserRemBal';
END IF;

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'KEYW';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table keyw';
END IF;

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'RESADID_BIDS';
IF v_count = 1 THEN
EXECUTE IMMEDIATE 'drop table resAdId_bidS';
END IF;

-- table resAdId_fi_1stA for storing fi value for GENERALIZED BALANCE FIRST AUCTION
SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'RESADID_FI_1STA';
IF v_count = 1 THEN
EXECUTE IMMEDIATE 'drop table resAdId_fi_1stA';
END IF;

-- table to store vector
SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'VECTOR';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table vector';
END IF;

-- table resAdId_fi_2ndA for storing fi value for GENERALIZED BALANCE SECOND AUCTION
SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'RESADID_FI_2NDA';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table resAdId_fi_2ndA';
END IF;

-- tables for storing ranks
SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'RESBRANK';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table resBRank';
END IF;

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'RESGRANK';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table resGRank';
END IF;

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'RESGBRANK';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table resGBRank';
END IF;

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'RESBRANK2A';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table resBRank2A';
END IF;

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'RESGRANK2A';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table resGRank2A';
END IF;

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'RESGBRANK2A';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table resGBRank2A';
END IF;

-- tables to store result
SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'OUTPUTGREEDY1STA';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table OutputGreedy1stA';
END IF;

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'OUTPUTBAL1STA';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table OutputBal1stA';
END IF;

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'OUTPUTGB1STA';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table OutputGB1stA';
END IF;

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'OUTPUTGREEDY2NDA';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table OutputGreedy2ndA';
END IF;

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'OUTPUTBAL2NDA';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table OutputBal2ndA';
END IF;

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'OUTPUTGB2NDA';
IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table OutputGB2ndA';
END IF;

END;
/
exit;
