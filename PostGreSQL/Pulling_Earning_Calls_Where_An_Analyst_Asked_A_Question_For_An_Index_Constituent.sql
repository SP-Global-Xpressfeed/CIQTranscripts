/************************************************************************************************
Returns Earning Calls where an analyst asked a question for an Index Constituent

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
POSTGRESQL

Query_Version:
V1

Query_Added_Date:
31/08/2020

DatasetKey:
11,36,100,45

The following sample query returns earnings calls where an analyst asked a question for an Index Constituent 
using the SP Capital IQ Transcripts package in Xpressfeed.

***********************************************************************************************/

SELECT DISTINCT c.companyId CIQCompanyID

, c.companyName CIQCompanyName, t.keyDevId ASKeyDevId, e.headline AS  EventHeadline, coalesce (concat(p.firstName,' ',p.middleName,' ',p.lastName) , tp.transcriptPersonName) AS NameOfPerson, 
pr.title AS  TitleOfPerson, coalesce (comp.companyName, tp.companyName) AS CompanyOfPerson,ic.fromDate

FROM ciqIndexProvider ip 

JOIN ciqIndex i  ON i.indexProviderID = ip.indexProviderID
JOIN ciqIndexConstituent ic  ON ic.indexID = i.indexID
JOIN ciqTradingItem ti  ON ti.tradingItemId = ic.tradingItemID
JOIN ciqSecurity s  ON s.securityId = ti.securityId
JOIN ciqCompany c  ON c.companyId = s.companyId
JOIN ciqEventToObjectToEventType ete  ON c.companyid = ete.objectid
JOIN ciqTranscript t  ON ete.keyDevId = t.keyDevId
JOIN ciqEvent e  ON e.keyDevId = t.keyDevId
JOIN ciqEventType et  ON et.keyDevEventTypeId = ete.keyDevEventTypeId
JOIN ciqTranscriptCollectionType tct  ON tct.transcriptCollectionTypeId = t.transcriptCollectionTypeId
JOIN ciqTranscriptPresentationType tpt  ON tpt.transcriptPresentationTypeId = t.transcriptPresentationTypeId
JOIN ciqEventCallBasicInfo ecb  ON ecb.keyDevId = t.keyDevId
JOIN ciqTranscriptComponent tc  ON t.transcriptId = tc.transcriptId
JOIN ciqTranscriptPerson tp  ON tc.transcriptPersonId = tp.transcriptPersonId
JOIN ciqTranscriptSpeakerType tst  ON tst.speakerTypeId = tp.speakerTypeId

LEFT OUTER JOIN ciqProfessional pr 

JOIN ciqPerson p  ON pr.personId = p.personId
JOIN ciqCompany comp  ON pr.companyId = comp.companyId ON tp.proId = pr.proId

WHERE ip.indexProviderID = 9 -- Standard and Poors US

AND i.indexID = '2668699' -- SP 500
AND (NOW() - interval '1 DAY') BETWEEN (ic.fromDate) AND (coalesce (ic.toDate,NOW()))
AND et.keyDevEventTypeId = 48 -- Earnings Call
AND t.transcriptCollectionTypeId = 1 -- Proofed Copy
AND tc.transcriptComponentTypeId = 3 -- Question
AND tp.speakerTypeId = 3 -- Analyst
AND coalesce (comp.companyName, tp.companyName) LIKE '%Goldman%Sachs%'


ORDER BY t.keyDevId


