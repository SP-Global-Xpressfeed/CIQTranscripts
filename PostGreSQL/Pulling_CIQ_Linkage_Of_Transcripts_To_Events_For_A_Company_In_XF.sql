/************************************************************************************************
Returns Linkage Of Transcripts To Events 

Packages Required:
Events 1 Year Rolling Daily
Textual Data Analytics - Transcripts (Core)

Universal Identifiers:
companyId

Primary Columns Used:
companyId
keyDevId
objectId
transcriptId

Database_Type:
POSTGRESQL

Query_Version:
V1

Query_Added_Date:
31/08/2020

DatasetKey:
11,36

The following sample query returns linkage of transcripts to events for a company using the 
SP Capital IQ Transcripts package in Xpressfeed.

***********************************************************************************************/

SELECT t.keyDevId

, t.transcriptId

, t.transcriptCreationDateUTC

, e.headline

, comp.companyId

, comp.companyName

FROM ciqTranscript t 

JOIN ciqEvent e  ON e.keyDevId = t.keyDevId

JOIN ciqEventToObjectToEventType ete  ON ete.keyDevId = t.keyDevId

JOIN ciqCompany comp  ON comp.companyId = ete.objectId

WHERE comp.companyid=24937 --Apple Inc.
