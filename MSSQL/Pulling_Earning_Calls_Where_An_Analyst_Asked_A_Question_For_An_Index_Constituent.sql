/************************************************************************************************
Returns Earning Calls Where An Analyst Asked A Question For An Index Constituent

Packages Required:
Euronext Constituent History
Euronext Index Level
Events 1 Year Rolling Daily
FTSE Index Level
Intel Professional
Textual Data Analytics - Transcripts (Core)
Transcripts History Span

Universal Identifiers:
companyId

Primary Columns Used:
companyId
indexID
indexProviderID
keyDevEventTypeId
keyDevId
objectId
personId
proId
securityId
speakerTypeId
tradingItemId
transcriptCollectionTypeId
transcriptComponentTypeId
transcriptId
transcriptPersonId
transcriptPresentationTypeId

Database_Type:
MSSQL

Query_Version:
V1

Query_Added_Date:
31/08/2020

DatasetKey:
11,36,100,45

The following sample query returns earnings calls where an analyst asked a question for an Index Constituent 
using the S&P Capital IQ Transcripts package in Xpressfeed.

***********************************************************************************************/

SELECT DISTINCT c.companyId CIQCompanyID

, c.companyName CIQCompanyName, t.keyDevId ASKeyDevId, e.headline AS  EventHeadline, ISNULL((p.firstName +   + p.middleName +   + p.lastName), tp.transcriptPersonName) AS NameOfPerson, 
pr.title AS  TitleOfPerson, ISNULL(comp.companyName, tp.companyName) AS CompanyOfPerson

FROM ciqIndexProvider ip (NOLOCK)

JOIN ciqIndex i (NOLOCK) ON i.indexProviderID = ip.indexProviderID
JOIN ciqIndexConstituent ic (NOLOCK) ON ic.indexID = i.indexID
JOIN ciqTradingItem ti (NOLOCK) ON ti.tradingItemId = ic.tradingItemID
JOIN ciqSecurity s (NOLOCK) ON s.securityId = ti.securityId
JOIN ciqCompany c (NOLOCK) ON c.companyId = s.companyId
JOIN ciqEventToObjectToEventType ete (NOLOCK) ON c.companyid = ete.objectid
JOIN ciqTranscript t (NOLOCK) ON ete.keyDevId = t.keyDevId
JOIN ciqEvent e (NOLOCK) ON e.keyDevId = t.keyDevId
JOIN ciqEventType et (NOLOCK) ON et.keyDevEventTypeId = ete.keyDevEventTypeId
JOIN ciqTranscriptCollectionType tct (NOLOCK) ON tct.transcriptCollectionTypeId = t.transcriptCollectionTypeId
JOIN ciqTranscriptPresentationType tpt (NOLOCK) ON tpt.transcriptPresentationTypeId = t.transcriptPresentationTypeId
JOIN ciqEventCallBasicInfo ecb (NOLOCK) ON ecb.keyDevId = t.keyDevId
JOIN ciqTranscriptComponent tc (NOLOCK) ON t.transcriptId = tc.transcriptId
JOIN ciqTranscriptPerson tp (NOLOCK) ON tc.transcriptPersonId = tp.transcriptPersonId
JOIN ciqTranscriptSpeakerType tst (NOLOCK) ON tst.speakerTypeId = tp.speakerTypeId

LEFT OUTER JOIN ciqProfessional pr (NOLOCK)

JOIN ciqPerson p (NOLOCK) ON pr.personId = p.personId
JOIN ciqCompany comp (NOLOCK) ON pr.companyId = comp.companyId ON tp.proId = pr.proId

WHERE ip.indexProviderID = 9 -- Standard and Poors US

AND i.indexID = 2668699 -- SP 500
AND (GETDATE()-1) BETWEEN (ic.fromDate)AND (ISNULL(ic.toDate,GETDATE()))AND et.keyDevEventTypeId = 48 -- Earnings Call
AND t.transcriptCollectionTypeId = 1 -- Proofed Copy
AND tc.transcriptComponentTypeId = 3 -- Question
AND tp.speakerTypeId = 3 -- Analyst
AND ISNULL(comp.companyName, tp.companyName) LIKE '%Goldman%Sachs%'

ORDER BY t.keyDevId
