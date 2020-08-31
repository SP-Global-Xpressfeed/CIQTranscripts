/************************************************************************************************
Returns Linakge Of Transcripts To Events 

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
MSSQL

Query_Version:
V1

Query_Added_Date:
31/08/2020

DatasetKey:
43,11

The following sample query returns linkage of transcripts to events for a company using the 
SP Capital IQ Transcripts package in Xpressfeed.

***********************************************************************************************/

SELECT t.keyDevId

, t.transcriptId

, t.transcriptCreationDateUTC

, e.headline

, comp.companyId

, comp.companyName

FROM ciqTranscript t (NOLOCK)

JOIN ciqEvent e (NOLOCK) ON e.keyDevId = t.keyDevId

JOIN ciqEventToObjectToEventType ete (NOLOCK) ON ete.keyDevId = t.keyDevId

JOIN ciqCompany comp (NOLOCK) ON comp.companyId = ete.objectId

WHERE comp.companyid=24937 --Apple Inc.