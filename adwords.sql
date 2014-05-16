CREATE OR REPLACE PROCEDURE ADWORDS (kTask1 IN int,
kTask2 IN int,kTask3 IN int,kTask4 IN int,kTask5 IN int,kTask6 IN int,
OPG1 OUT sys_refcursor,OPB1 OUT sys_refcursor,OPGB1 OUT sys_refcursor,
OPG2 OUT sys_refcursor,OPB2 OUT sys_refcursor,OPGB2 OUT sys_refcursor) AS
qCnt integer;
chk integer;
v_count number;
j int;
str VARCHAR2(100);
clickCntr NUMBER;
ctcMby100 number;

BEGIN

--insert into AdvertiserRemBal

insert into AdvertiserRemBal(select advertiserid,budget,ctc*100,budget,budget,budget,
budget,budget,budget,0,0,0,0,0,0 from advertisers);

--Loop through all queries
select max(qid) into qCnt from queries;
--for idq in(select qid from queries order by qid)
FOR idq IN 1..qCnt
loop          

select count(*) into chk from QUERIES where qid=idq;
IF chk = 0 then 
CONTINUE;
END IF;

delete from keyw;
delete from resAdId_bidS;
delete from resAdId_fi_1stA;
delete from resAdId_fi_2ndA;
delete from vector;
delete from resGRank;
delete from resBRank;
delete from resGBRank;
delete from resGRank2A;
delete from resBRank2A;
delete from resGBRank2A;
delete from bidSG2;
delete from bidSB2;
delete from bidSGB2;


--Tokenizing 
select regexp_count(query, '[^ ]+') into j from Queries where qid=idq;
  for cntr in 1..j  
  loop
    SELECT REGEXP_SUBSTR(query,'[^'||' '||']'||'+',1,cntr) into str FROM queries where qid=idq;
    insert into keyw(keyId,word) values(cntr, str);
  
  end loop;

--Calculating count of keywords for the query
update keyw k set k.keycount=(select count(word) as keycount from keyw kk
where k.word=kk.word group by word);

--Deleting duplicate keys
delete from keyw A where A.rowid> ANY(select B.rowid from keyw B where
A.word=B.word);

--Get Bid sum of the Advertisers (including invalid bidders)
insert into resAdId_bidS (select k.advertiserid,sum(k.bid) as bidsum from Keywords k
where UPPER(keyword) in (select distinct UPPER(word) from keyw) group by
k.advertiserid);

insert into bidSG2 (select adid,bids from resAdId_bidS r,AdvertiserRemBal a where r.adId=a.advertiserid and balG2>=bids);
insert into bidSB2 (select adid,bids from resAdId_bidS r,AdvertiserRemBal a where r.adId=a.advertiserid and balB2>=bids);
insert into bidSGB2 (select adid,bids from resAdId_bidS r,AdvertiserRemBal a where r.adId=a.advertiserid and balGB2>=bids);

--Storing FI value for Generalized Balance 1st auction algo
insert into resAdId_fi_1stA(select a.advertiserid,sum(k.bid)*(1-EXP(-(a.balGB1/ a.budget))) as fi 
from AdvertiserRemBal a 
inner join Keywords k on
a.advertiserid=k.advertiserid where UPPER(keyword) in (select distinct UPPER(word) from keyw) group by
a.advertiserid,a.balGB1, a.budget);

--Storing FI value for Generalized Balance 2nd auction algo
insert into resAdId_fi_2ndA(select a.advertiserid,sum(k.bid)*(1-EXP(-(a.balGB2/ a.budget))) as fi 
from AdvertiserRemBal a 
inner join Keywords k on
a.advertiserid=k.advertiserid where UPPER(keyword) in (select distinct UPPER(word) from keyw) group by
a.advertiserid,a.balGB2, a.budget);

--Calculate VECTOR
for b in (select adId from resAdId_bidS)
loop
  insert into vector(QKEYCOUNT, adidkeycount, adid) select nvl(q.keycount,0),nvl(c,0),b.adId
  from keyW q 
  FULL outer join (select count(keyword) as c,keyword
  from keywords where advertiserid=b.adId group by keyword) kk on UPPER(q.word)=UPPER(kk.keyword);
end loop;

--Get Balanced 1st auction ranks of all the valid bidders
insert into resBRank (select ROW_NUMBER()
   OVER (ORDER BY res1.QS*res.balB1 desc,res1.adid asc),res1.adid, res.balB1 from (select sim.adid as adid,a.ctc*sim.similarity QS from 
(select adid,
(sum(v.QKEYCOUNT*v.ADIDKEYCOUNT))/(sqrt(sum(v.ADIDKEYCOUNT*v.ADIDKEYCOUNT)*sqrt(sum(v.QKEYCOUNT*v.QKEYCOUNT))))
as similarity from vector v
group by ADID ) sim inner join Advertisers a on sim.adid= a.advertiserid) res1 
inner join AdvertiserRemBal res on res.advertiserId=res1.adid WHERE res.balB1>=(select bids from 
resAdid_bids where adid= res.advertiserid));

--Get Balanced 2nd auction ranks of all the valid bidders
insert into resBRank2A (select ROW_NUMBER()
   OVER (ORDER BY res1.QS*res.balB2 desc,res1.adid asc),res1.adid, res.balB2 from (select sim.adid as adid,a.ctc*sim.similarity QS from 
(select adid,
(sum(v.QKEYCOUNT*v.ADIDKEYCOUNT))/(sqrt(sum(v.ADIDKEYCOUNT*v.ADIDKEYCOUNT)*sqrt(sum(v.QKEYCOUNT*v.QKEYCOUNT))))
as similarity from vector v
group by ADID ) sim inner join Advertisers a on sim.adid= a.advertiserid) res1 
inner join AdvertiserRemBal res on res.advertiserId=res1.adid WHERE res.balB2>=(select bids from 
resAdid_bids where adid= res.advertiserid));

--Get Greedy 1st auction ranks of all the valid bidders
insert into resGRank(select ROW_NUMBER()
   OVER (ORDER BY res1.QS*res.bidS desc,res1.adid asc),res1.adid, ab.balG1 from (
   select sim.adid as adid,a.ctc*sim.similarity QS from 
(select adid,
(sum(v.QKEYCOUNT*v.ADIDKEYCOUNT))/(sqrt(sum(v.ADIDKEYCOUNT*v.ADIDKEYCOUNT)*sqrt(sum(v.QKEYCOUNT*v.QKEYCOUNT))))
as similarity from vector v
group by ADID ) sim inner join Advertisers a on sim.adid= a.advertiserid) res1 
inner join resAdId_bidS res on res.adid=res1.adid 
inner join AdvertiserRemBal ab on res.adid=ab.advertiserId WHERE ab.balG1>=res.bids);

--Get Greedy 2nd auction ranks of all the valid bidders
insert into resGRank2A(select ROW_NUMBER()
   OVER (ORDER BY res1.QS*res.bidS desc,res1.adid asc),res1.adid, ab.balG2 from (select sim.adid as adid,a.ctc*sim.similarity QS from 
(select adid,
(sum(v.QKEYCOUNT*v.ADIDKEYCOUNT))/(sqrt(sum(v.ADIDKEYCOUNT*v.ADIDKEYCOUNT)*sqrt(sum(v.QKEYCOUNT*v.QKEYCOUNT))))
as similarity from vector v
group by ADID ) sim inner join Advertisers a on sim.adid= a.advertiserid) res1 
inner join resAdId_bidS res on res.adid=res1.adid 
inner join AdvertiserRemBal ab on res.adid=ab.advertiserId WHERE ab.balG2>=res.bids);

--Get Generalized Balanced 1st auction ranks of all the valid bidders
insert into resGBRank(select ROW_NUMBER()
   OVER (ORDER BY res1.QS*res.fi desc,res1.adid asc),res1.adid, ab.balGB1 from 
   (select sim.adid as adid,a.ctc*sim.similarity QS from 
(select adid,
(sum(v.QKEYCOUNT*v.ADIDKEYCOUNT))/(sqrt(sum(v.ADIDKEYCOUNT*v.ADIDKEYCOUNT)*sqrt(sum(v.QKEYCOUNT*v.QKEYCOUNT))))
as similarity from vector v
group by ADID ) sim inner join Advertisers a on sim.adid= a.advertiserid) res1 
inner join resAdId_fi_1stA res on res.adid=res1.adid 
inner join AdvertiserRemBal ab on res.adid=ab.advertiserId WHERE ab.balGB1>=(select bids from 
resAdid_bids where adid= ab.advertiserid));

--Get Generalized Balanced 2nd auction ranks of all the valid bidders
insert into resGBRank2A(select ROW_NUMBER()
   OVER (ORDER BY res1.QS*res.fi desc,res1.adid asc),res1.adid, ab.balgb2 from 
   (select sim.adid as adid,a.ctc*sim.similarity QS from 
(select adid,
(sum(v.QKEYCOUNT*v.ADIDKEYCOUNT))/(sqrt(sum(v.ADIDKEYCOUNT*v.ADIDKEYCOUNT)*sqrt(sum(v.QKEYCOUNT*v.QKEYCOUNT))))
as similarity from vector v
group by ADID ) sim inner join Advertisers a on sim.adid= a.advertiserid) res1 
inner join resAdId_fi_2ndA res on res.adid=res1.adid 
inner join AdvertiserRemBal ab on res.adid=ab.advertiserId WHERE ab.balgb2>=(select bids from 
resAdid_bids where adid= ab.advertiserid));

--Getting output for Greedy 1st auction
delete from resGRank where rowid not in (select rowid from resGRank where rownum <=kTask1);

  for tempAdid in (select adid from resGRank)
  loop
  --select bal from resAdId_bud_bidS where adid= tempAdid; desc AdvertiserRemBal
  select DISCNTRG1 into clickCntr from AdvertiserRemBal where advertiserid=tempAdid.adid;
  select ctcm100 into ctcMby100 from AdvertiserRemBal where advertiserid=tempAdid.adid;
  if clickCntr<ctcMby100 then 
  
  update AdvertiserRemBal set balG1= balG1-(select bidS from resAdId_bidS where adid=tempAdid.adid)where advertiserid=tempAdid.adid;
  --update resGRank set bal=(select bal-bidS from resAdId_bidS where adid=tempAdid.adid) where adid=tempAdid.adid;  
  update resGRank set bal=(select balG1 from AdvertiserRemBal where advertiserId=tempAdid.adid) where adid=tempAdid.adid;
 -- update resGRank set bal=bal-(select bidS from resAdId_bidS where adid=tempAdid.adid)where advertiserid=tempAdid.adid;
   end if;
  
  update AdvertiserRemBal set DISCNTRG1= 
  case clickCntr when 99 then 0
  else DISCNTRG1+1
    end where ADVERTISERID=tempAdid.adid;
  
  end loop;
  
  --Successfully executed

insert into OutputGreedy1stA(select idq,grank,adid,bal,budget from resgrank inner join advertisers on resgrank.adid=advertisers.advertiserid);

--Output for Generalized Balanced 1st auction
delete from resGBRank where rowid not in (select rowid from resGBRank where rownum <=kTask5);

for tempAdid in (select adid from resGBRank)
  loop
  --select bal from resAdId_bud_bidS where adid= tempAdid;
  select discntrGB1 into clickCntr from AdvertiserRemBal where advertiserid=tempAdid.adid;
  select ctcm100 into ctcMby100 from AdvertiserRemBal where advertiserid=tempAdid.adid;
  if clickCntr<ctcMby100 then 
  
  update AdvertiserRemBal set balGB1= balGB1-(select bidS from resAdId_bidS where adid=tempAdid.adid)
  where advertiserid=tempAdid.adid;
 
  update resGBRank set bal=(select balGB1 from AdvertiserRemBal where 
  advertiserId=tempAdid.adid) where adid=tempAdid.adid;
   end if;
  
  update AdvertiserRemBal set discntrgb1= 
  case clickCntr when 99 then 0
  else discntrgb1+1
    end where ADVERTISERID=tempAdid.adid;
  
  end loop;
  
    insert into OutputGB1stA(select idq,gbrank,adid,bal,budget from resgbrank 
inner join advertisers on resgbrank.adid=advertisers.advertiserid);

--Output for Balanced 1st auction
delete from resBRank where rowid not in (select rowid from resBRank where rownum <=kTask3);

 for tempAdid in (select adid from resBRank)
  loop
  --select bal from resAdId_bud_bidS where adid= tempAdid;
  select discntrb1 into clickCntr from AdvertiserRemBal where advertiserid=tempAdid.adid;
  select ctcm100 into ctcMby100 from AdvertiserRemBal where advertiserid=tempAdid.adid;
  if clickCntr<ctcMby100 then 
  
  update AdvertiserRemBal set balB1= balB1-(select bidS from resAdId_bidS where adid=tempAdid.adid)
  where advertiserid=tempAdid.adid;
   
  update resBRank set bal=(select balB1 from AdvertiserRemBal where 
  advertiserId=tempAdid.adid) where adid=tempAdid.adid;
   end if;
 
  update AdvertiserRemBal set discntrb1= 
  case clickCntr when 99 then 0
  else discntrB1+1
    end where ADVERTISERID=tempAdid.adid;
  
  end loop;
  
  insert into OutputBal1stA(select idq,brank,adid,bal,budget from resbrank 
inner join advertisers on resbrank.adid=advertisers.advertiserid);


--Output for Greedy 2nd auction
delete from resGRank2A where rowid not in (select rowid from resGRank2A where rownum <=kTask2);

for tempAdid in (select adid from resGRank2A)
  loop
 
  select discntrG2 into clickCntr from AdvertiserRemBal where advertiserid=tempAdid.adid;
  select ctcm100 into ctcMby100 from AdvertiserRemBal where advertiserid=tempAdid.adid;
  if clickCntr<ctcMby100 then 
  
  update AdvertiserRemBal ab set balG2= balG2-(select nvl((select max(bidS)
  from bidSG2 where adid!=tempAdid.adid
 -- and adid in(select adid from resGRank2A)
  and bids not in(select bids from bidSG2 where bids>=(select bids from bidSG2 where adid=tempAdid.adid))),
  (select bids from bidSG2 where adid=tempAdid.adid)) from dual)
  where ab.advertiserid=tempAdid.adid;
 
  update resGRank2A set bal=(select balG2 from AdvertiserRemBal where 
  advertiserId=tempAdid.adid) where adid=tempAdid.adid;
   end if;
  
  update AdvertiserRemBal set discntrG2= 
  case clickCntr when 99 then 0
  else discntrG2+1
    end where ADVERTISERID=tempAdid.adid;
  
  end loop;
  
  --successfully executed
  
   insert into OutputGreedy2ndA(select idq,grank,adid,bal,budget from resgrank2a 
inner join advertisers on resgrank2a.adid=advertisers.advertiserid);


--Output fot Balanced 2nd auction
delete from resBRank2A where rowid not in (select rowid from resBRank2A where rownum <=kTask4);

 for tempAdid in (select adid from resBRank2A)
  loop
  --select bal from resAdId_bud_bidS where adid= tempAdid;
  select discntrB2 into clickCntr from AdvertiserRemBal where advertiserid=tempAdid.adid;
  select ctcm100 into ctcMby100 from AdvertiserRemBal where advertiserid=tempAdid.adid;
  if clickCntr<ctcMby100 then 
  
  update AdvertiserRemBal ab set balB2= balB2-(select nvl((select max(bidS)
  from bidSB2 where adid!=tempAdid.adid
 -- and adid in(select adid from resBRank2A)
  and bids not in(select bids from bidSB2 where bids>=(select bids from bidSB2 where adid=tempAdid.adid))),
  (select bids from bidSB2 where adid=tempAdid.adid)) from dual)
  where ab.advertiserid=tempAdid.adid;
   
  update resBRank2A set bal=(select balB2 from AdvertiserRemBal where 
  advertiserId=tempAdid.adid) where adid=tempAdid.adid;
   end if;
  
  update AdvertiserRemBal set discntrB2= 
  case clickCntr when 99 then 0
  else discntrB2+1
    end where ADVERTISERID=tempAdid.adid;
  
  end loop;
 
   insert into OutputBal2ndA(select idq,brank,adid,bal,budget from resBRank2A 
inner join advertisers on resBRank2A.adid=advertisers.advertiserid);

--Output for Generalized balanced 2nd auction
delete from resGBRank2A where rowid not in (select rowid from resGBRank2A where rownum <=kTask6);

 for tempAdid in (select adid from resGBRank2A)
  loop
  --select bal from resAdId_bud_bidS where adid= tempAdid;
  select discntrGB2 into clickCntr from AdvertiserRemBal where advertiserid=tempAdid.adid;
  select ctcm100 into ctcMby100 from AdvertiserRemBal where advertiserid=tempAdid.adid;
  if clickCntr<ctcMby100 then 
  
  update AdvertiserRemBal ab set balGB2= balGB2-(select nvl((select max(bidS)
  from bidSGB2 where adid!=tempAdid.adid
  and bids not in(select bids from bidSGB2 where bids>=(select bids from bidSGB2 where adid=tempAdid.adid))),
  (select bids from bidSGB2 where adid=tempAdid.adid)) from dual)
  where ab.advertiserid=tempAdid.adid;
 
  update resGBRank2A set bal=(select balGB2 from AdvertiserRemBal where 
  advertiserId=tempAdid.adid) where adid=tempAdid.adid;
   end if;
  
  update AdvertiserRemBal set discntrGB2= 
  case clickCntr when 99 then 0
  else discntrGB2+1
    end where ADVERTISERID=tempAdid.adid;
  
  end loop;
 
  insert into OutputGB2ndA(select idq,GBrank,adid,bal,budget from resGBRank2A 
inner join advertisers on resGBRank2A.adid=advertisers.advertiserid);

END LOOP;

--Return all outputs
OPEN opg1 FOR SELECT qid,rank,advertiserid,balance,budget from outputgreedy1sta;
OPEN opb1 FOR SELECT qid,rank,advertiserid,balance,budget from OutputBal1stA;
OPEN opgb1 FOR SELECT qid,rank,advertiserid,balance,budget from OutputGB1stA;
OPEN opg2 FOR SELECT qid,rank,advertiserid,balance,budget from outputgreedy2nda;
OPEN opb2 FOR SELECT qid,rank,advertiserid,balance,budget from outputbal2nda;
OPEN opgb2 FOR SELECT qid,rank,advertiserid,balance,budget from outputgb2nda;

END ADWORDS;
/
exit;
--Drop PROCEDURE TryProc
--variable b REFCURSOR;begin
--EXECUTE TryProc(5,5,5,5,5,:b,:b,:b,:b,:b); 
--call tryproc(5,5,5,5,5,:b,:b,:b,:b,:b);
--end; DESC OUTPUTBAL1STA