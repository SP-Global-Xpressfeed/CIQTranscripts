/************************************************************************************************
Returns aggregate count of mentions of a specific keyword

Packages Required:
Euronext Constituent History
Euronext Index Level
Events 1 Year Rolling Daily
Textual Data Analytics - Transcripts (Core)
Transcripts History Span

Universal Identifiers:
companyId

Primary Columns Used:
companyId
constituentID
indexID
keyDevEventTypeId
keyDevId
objectId
securityId
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
43,100

The following sample query returns aggregate count of mentions of a specific keyword, such as weather for this example, 
during earnings calls for an index by year using the SP Capital IQ Transcripts package in Xpressfeed.

***********************************************************************************************/

SELECT COUNT (DISTINCT t.keydevid) AS COUNT

, date_part ('year',mostImportantDateUTC) AS YEAR

FROM ciqTranscript t 

JOIN ciqTranscriptCollectionType tct  ON tct.transcriptCollectionTypeId = t.transcriptCollectionTypeId
JOIN ciqTranscriptComponent tc  ON tc.transcriptid = t.transcriptId
JOIN ciqTranscriptPerson p  ON p.transcriptpersonid = tc.transcriptpersonid
JOIN ciqEvent e  ON e.keyDevId = t.keyDevId
JOIN ciqEventToObjectToEventType ete  ON ete.keyDevId = t.keyDevId
JOIN ciqCompany comp  ON comp.companyId = ete.objectId
JOIN ciqSecurity s  ON s.companyid=comp.companyid
AND s.primaryFlag=1
JOIN ciqConstituent cc  ON cc.securityid=s.securityid
JOIN ciqIndexConstituent cic  ON cic.constituentid=cc.constituentid
AND cic.todate IS NULL -- current constituent
JOIN ciqIndex ci  ON ci.indexid=cic.indexid

WHERE 1=1

AND ete.keyDevEventTypeId=48 --Earnings Calls
AND t.transcriptPresentationTypeId=5 --Final
AND tct.transcriptCollectionTypeId=1 --Proofed Copy
AND tc.transcriptcomponentTypeId=2 --Presenters Speach
AND ci.indexid=5466717--SP 500 Retail Composite
AND tc.componenttext LIKE '%weather%'

GROUP BY date_part ('year',mostImportantDateUTC) ORDER BY date_part ('year',mostImportantDateUTC) DESC
