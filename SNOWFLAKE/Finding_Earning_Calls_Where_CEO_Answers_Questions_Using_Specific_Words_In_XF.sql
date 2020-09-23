/************************************************************************************************
Returns Earning Calls Where CEO Answers Questions Using Specific Keywords For A Company

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
SNOWFLAKE

Query_Version:
V1

Query_Added_Date:
31/08/2020

DatasetKey:
11,36,45

The following sample query earnings calls where CEO answers questions using specific keywords using the 
S&P Capital IQ Transcripts package in Xpressfeed. This example uses earnings calls where Tim Cook
answered a question for Apple Inc using the word acquisition.

***********************************************************************************************/

--NOTE---Suggest to create Full Text (componenttext) and Non Clustered Index (transcriptId, transcriptComponentId,componentOrder,transcriptComponentTypeId,transcriptPersonId)on the table ciqTranscriptComponent
---for better performance of the query. Creating Index may consume some of your database disk space---NOTE--

SELECT p.transcriptpersonname

, e.headline, tc.componenttext

FROM ciqTranscript t (NOLOCK)

JOIN ciqTranscriptCollectionType tct (NOLOCK) ON tct.transcriptCollectionTypeId = t.transcriptCollectionTypeId
JOIN ciqTranscriptPresentationType tpt (NOLOCK) ON tpt.transcriptPresentationTypeId = t.transcriptPresentationTypeId
JOIN ciqTranscriptComponent tc (NOLOCK) ON tc.transcriptid = t.transcriptId
JOIN ciqTranscriptComponentType tcty (NOLOCK) ON tcty.transcriptcomponenttypeid=tc.transcriptComponentTypeId
JOIN ciqTranscriptPerson p (NOLOCK) ON p.transcriptpersonid = tc.transcriptpersonid
JOIN ciqEvent e (NOLOCK) ON e.keyDevId = t.keyDevId
JOIN ciqEventToObjectToEventType ete (NOLOCK) ON ete.keyDevId = t.keyDevId
JOIN ciqCompany comp (NOLOCK) ON comp.companyId = ete.objectId
JOIN ciqEventType et (NOLOCK) ON et.keyDevEventTypeId = ete.keyDevEventTypeId

WHERE 1=1

AND et.keyDevEventTypeId=48 --Earnings Calls
AND t.transcriptPresentationTypeId=5 --Final
AND tct.transcriptCollectionTypeId=1 --Proofed Copy
AND tcty.transcriptcomponentTypeId=4 --Answer
AND comp.companyid=24937 --Apple Inc.
AND p.proid=169601 --Timothy Cook
AND tc.componenttext LIKE '%acquisition%'
