/************************************************************************************************
Returns Earning Calls For A Company

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

The following sample query returns earnings calls for a company using specific keywords using the SP Capital IQ 
Transcripts package in Xpressfeed. This example uses earnings calls for Macys / Nordstrom / J.C. Penny 
using the word weather.

***********************************************************************************************/

--NOTE---Suggest to create Full Text (componenttext) and Non Clustered Index (transcriptId, transcriptComponentId,componentOrder,transcriptComponentTypeId,transcriptPersonId)on the table ciqTranscriptComponent
---for better performance of the query. Creating Index may consume some of your database disk space---NOTE--

SELECT comp.companyid
, comp.companyname
, COUNT (DISTINCT t.keydevid) AS COUNT
, DATE_PART('year',mostImportantDateUTC) AS YEAR

FROM ciqTranscript t 

JOIN ciqTranscriptCollectionType tct  ON tct.transcriptCollectionTypeId = t.transcriptCollectionTypeId
JOIN ciqTranscriptPresentationType tpt  ON tpt.transcriptPresentationTypeId = t.transcriptPresentationTypeId
JOIN ciqTranscriptComponent tc  ON tc.transcriptid = t.transcriptId
JOIN ciqTranscriptComponentType tcty  ON tcty.transcriptcomponenttypeid=tc.transcriptComponentTypeId
JOIN ciqTranscriptPerson p  ON p.transcriptpersonid = tc.transcriptpersonid
JOIN ciqEvent e  ON e.keyDevId = t.keyDevId
JOIN ciqEventToObjectToEventType ete  ON ete.keyDevId = t.keyDevId
JOIN ciqEventType et  ON et.keyDevEventTypeId = ete.keyDevEventTypeId
JOIN ciqCompany comp  ON comp.companyId = ete.objectId

WHERE 1=1

AND et.keyDevEventTypeId=48 --Earnings Calls
AND t.transcriptPresentationTypeId=5 --Final
AND tct.transcriptCollectionTypeId=1 --Proofed Copy
AND tcty.transcriptcomponentTypeId=2 --Presenters Speach
AND comp.companyid IN (318091,32215,295624)AND tc.componenttext LIKE '%weather%'

GROUP BY comp.companyid

, comp.companyname, DATE_PART('year',mostImportantDateUTC)

ORDER BY comp.companyname

, DATE_PART('year',mostImportantDateUTC) DESC