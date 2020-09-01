/************************************************************************************************
Returns aggregate count of distinct analysts who asked a question during quarterly earnings call

Packages Required:
Events 1 Year Rolling Daily
Textual Data Analytics - Transcripts (Core)
Transcripts History Span

Universal Identifiers:
companyId

Primary Columns Used:
companyId
keyDevEventTypeId
keyDevId
objectId
speakerTypeId
transcriptCollectionTypeId
transcriptComponentTypeId
transcriptId
transcriptPersonId
transcriptPresentationTypeId

Database_Type:
POSTGRESQL

Query_Version:
V1

Query_Added_Date:
31/08/2020

DatasetKey:
43

The following sample query returns aggregate count of distinct analysts who asked a question 
for a companys quarterly earnings call using the S&P Capital IQ Transcripts package in Xpressfeed.
(Here for Apple Inc.)

***********************************************************************************************/

SELECT comp.companyid
, COUNT (DISTINCT p.transcriptpersonid) as
AnalystCount
,SUBSTRING(headline, strpos(headline,'Earnings Call' ) - 8, 7) AS
QuarterFiscalYear--,headline
 
FROM ciqTranscript t 

JOIN ciqTranscriptCollectionType tct  ON tct.transcriptCollectionTypeId =t.transcriptCollectionTypeId
JOIN ciqTranscriptPresentationType tpt  ON tpt.transcriptPresentationTypeId =t.transcriptPresentationTypeId
JOIN ciqTranscriptComponent tc  ON tc.transcriptid = t.transcriptId
JOIN ciqTranscriptComponentType tcty  ON tcty.transcriptcomponenttypeid=tc.transcriptComponentTypeId
JOIN ciqTranscriptPerson p  ON p.transcriptpersonid = tc.transcriptpersonid
JOIN ciqEvent e  ON e.keyDevId = t.keyDevId
JOIN ciqEventToObjectToEventType ete  ON ete.keyDevId = t.keyDevId
JOIN ciqCompany comp  ON comp.companyId = ete.objectId
JOIN ciqEventType et  ON et.keyDevEventTypeId = ete.keyDevEventTypeId

WHERE 1=1

AND et.keyDevEventTypeId='48' --Earnings Calls
AND t.transcriptPresentationTypeId='5' --Final
AND tct.transcriptCollectionTypeId='1' --Proofed Copy
AND p.speakerTypeId='3' --Analyst
AND tcty.transcriptcomponentTypeId='3' --Question
AND e.headline like '%Q4%'
AND comp.companyid='24937' --Apple Inc.

GROUP BY comp.companyid,SUBSTRING(headline, strpos(headline,'Earnings Call' ) - 8, 7),headline
ORDER BY comp.companyid, SUBSTRING(headline, strpos(headline,'Earnings Call' ) - 8, 7) desc




