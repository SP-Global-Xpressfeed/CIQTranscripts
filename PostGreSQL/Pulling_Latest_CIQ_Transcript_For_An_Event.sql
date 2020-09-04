/************************************************************************************************
Returns Latest Transcript For An Event

Packages Required:
Transcripts History Span

Universal Identifiers:
NULL

Primary Columns Used:
transcriptId

Database_Type:
POSTGRESQL

Query_Version:
V1

Query_Added_Date:
31/08/2020

DatasetKey:
45

The following sample query returns latest transcript for an event using the SP Capital IQ Transcripts package in Xpressfeed.

***********************************************************************************************/

SELECT *FROM (SELECT keydevid, MAX (transcriptID) latestTranscriptId

FROM ciqtranscript
WHERE keyDevId = 1033670

GROUP BY keydevid ) a

JOIN ciqTranscriptComponent b ON a.latestTranscriptId = b.transcriptId

WHERE a.keyDevId = 1033670
