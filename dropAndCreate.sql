DECLARE v_count NUMBER;
BEGIN

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'ADVERTISERS';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'DROP TABLE ADVERTISERS';
END IF;

EXECUTE IMMEDIATE 'create table Advertisers(advertiserid number,budget number(38,3), ctc number(38,3))';

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'KEYWORDS';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'DROP TABLE KEYWORDS';
END IF;

EXECUTE IMMEDIATE 'create table Keywords(advertiserid number, keyword varchar2(100), bid number(38,3))';


SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'QUERIES';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'DROP TABLE QUERIES';
END IF;

EXECUTE IMMEDIATE 'create table QUERIES(qid number, query varchar2(500))';


SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'ADVERTISERREMBAL';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table AdvertiserRemBal';
END IF;

EXECUTE IMMEDIATE 'create global temporary table AdvertiserRemBal(advertiserId number, budget number(38,3),ctcM100 integer,
balG1 number(38,3),balB1 number(38,3),balGB1 number(38,3),
balG2 number(38,3),balB2 number(38,3),balGB2 number(38,3),
DisCntrG1 integer,DisCntrB1 integer,DisCntrGB1 integer,DisCntrG2 integer,
DisCntrB2 integer,DisCntrGB2 integer)';


-- table to store keywords of query
SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'KEYW';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table keyw';
END IF;

EXECUTE IMMEDIATE 'create global temporary table keyw(keyId int primary key, word varchar2(100),keycount int)';

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'RESADID_BIDS';

IF v_count = 1 THEN
EXECUTE IMMEDIATE 'drop table resAdId_bidS';
END IF;

EXECUTE IMMEDIATE 'create global temporary table resAdId_bidS(adID number,bidS number(38,3))';

IF v_count = 1 THEN
EXECUTE IMMEDIATE 'drop table BIDSGB2';
END IF;

EXECUTE IMMEDIATE 'create global temporary table BIDSGB2(adID number,bidS number(38,3))';

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'BIDSG2';

IF v_count = 1 THEN
EXECUTE IMMEDIATE 'drop table BIDSG2';
END IF;

EXECUTE IMMEDIATE 'create global temporary table BIDSG2(adID number,bidS number(38,3))';

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'BIDSB2';

IF v_count = 1 THEN
EXECUTE IMMEDIATE 'drop table BIDSB2';
END IF;

EXECUTE IMMEDIATE 'create global temporary table BIDSB2(adID number,bidS number(38,3))';


-- table resAdId_fi_1stA for storing fi value for GENERALIZED BALANCE FIRST AUCTION
SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'RESADID_FI_1STA';

IF v_count = 1 THEN
EXECUTE IMMEDIATE 'drop table resAdId_fi_1stA';
END IF;

EXECUTE IMMEDIATE 'create global temporary table resAdId_fi_1stA(adid number,fi float)';

-- table to store vector
SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'VECTOR';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table vector';
END IF;

EXECUTE IMMEDIATE 'create global temporary table vector(qKeyCount int,adIdKeyCount int, adId varchar2(100))';

-- table resAdId_fi_2ndA for storing fi value for GENERALIZED BALANCE SECOND AUCTION
SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'RESADID_FI_2NDA';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table resAdId_fi_2ndA';
END IF;

EXECUTE IMMEDIATE 'create global temporary table resAdId_fi_2ndA(adid number,fi float)';

-- tables for storing ranks
SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'RESBRANK';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table resBRank';
END IF;
/*create global temporary table resRanks(adid number,G1Rank float,B1Rank float,GB1Rank float,G2Rank float,
B2Rank float,GB2Rank float)*/ 
EXECUTE IMMEDIATE 'create global temporary table resBRank(brank float,adid number,bal number(38,3))';

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'RESGRANK';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table resGRank';
END IF;

EXECUTE IMMEDIATE 'create  global temporary table resGRank(grank float,adid number,bal number(38,3))';

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'RESGBRANK';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table resGBRank';
END IF;

EXECUTE IMMEDIATE 'create global temporary table resGBRank(gbrank float,adid number,bal number(38,3))';

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'RESBRANK2A';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table resBRank2A';
END IF;

EXECUTE IMMEDIATE 'create global temporary table resBRank2A(brank float,adid number,bal number(38,3))';

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'RESGRANK2A';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table resGRank2A';
END IF;

EXECUTE IMMEDIATE 'create global temporary table resGRank2A(grank float,adid number,bal number(38,3))';

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'RESGBRANK2A';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table resGBRank2A';
END IF;

EXECUTE IMMEDIATE 'create global temporary table resGBRank2A(gbrank float,adid number,bal number(38,3))';

-- tables to store result
SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'OUTPUTGREEDY1STA';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table OutputGreedy1stA';
END IF;

EXECUTE IMMEDIATE 'create table OutputGreedy1stA(qid number,rank int,advertiserId number, balance number(38,3),budget number(38,3))';

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'OUTPUTBAL1STA';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table OutputBal1stA';
END IF;

EXECUTE IMMEDIATE 'create table OutputBal1stA(qid number,rank int,advertiserId number, balance number(38,3),budget number(38,3))';

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'OUTPUTGB1STA';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table OutputGB1stA';
END IF;

EXECUTE IMMEDIATE 'create table OutputGB1stA(qid number,rank int,advertiserId number, balance number(38,3),budget number(38,3))';

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'OUTPUTGREEDY2NDA';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table OutputGreedy2ndA';
END IF;

EXECUTE IMMEDIATE 'create table OutputGreedy2ndA(qid number,rank int,advertiserId number, balance number(38,3),budget number(38,3))';

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'OUTPUTBAL2NDA';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table OutputBal2ndA';
END IF;

EXECUTE IMMEDIATE 'create table OutputBal2ndA(qid number,rank int,advertiserId number, balance number(38,3),budget number(38,3))';

SELECT COUNT (*) INTO v_count FROM user_tables
WHERE  table_name = 'OUTPUTGB2NDA';

IF v_count = 1 THEN 
EXECUTE IMMEDIATE 'drop table OutputGB2ndA';
END IF;

EXECUTE IMMEDIATE 'create table OutputGB2ndA(qid number,rank int,advertiserId number, balance number(38,3),budget number(38,3))';

END;
/
exit;
