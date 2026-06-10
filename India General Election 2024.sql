CREATE TABLE statewise_res (
    state_id VARCHAR(5) PRIMARY KEY,
    state TEXT
);

SELECT * FROM constituencywise_details;
SELECT * FROM constituencywise_results;
SELECT * FROM partywise_results;
SELECT * FROM statewise_results;
SELECT * FROM states;

--total seats
SELECT 
DISTINCT COUNT(parliament_constituency) as Total_seats
from
constituencywise_results;

--what are the number of seats available for elections in each state
SELECT 
    s.states AS state_name,
    COUNT(cr.parliament_constituency) AS total_seats
FROM
    constituencywise_results cr
INNER JOIN statewise_results sr 
    ON cr.parliament_constituency = sr.parliament_constituency
INNER JOIN states s 
    ON sr.state_id = s.state_id
GROUP BY 
    s.states;


--Total seats won by NDA Allience

SELECT 
	SUM(CASE
			WHEN party IN(
				'Bharatiya Janata Party - BJP', 
                'Telugu Desam - TDP', 
				'Janata Dal  (United) - JD(U)',
                'Shiv Sena - SHS', 
                'AJSU Party - AJSUP', 
                'Apna Dal (Soneylal) - ADAL', 
                'Asom Gana Parishad - AGP',
                'Hindustani Awam Morcha (Secular) - HAMS', 
                'Janasena Party - JnP', 
				'Janata Dal  (Secular) - JD(S)',
                'Lok Janshakti Party(Ram Vilas) - LJPRV', 
                'Nationalist Congress Party - NCP',
                'Rashtriya Lok Dal - RLD', 
                'Sikkim Krantikari Morcha - SKM'

				)THEN won
				else 0
				END) AS NDA_Total_Seats_won
from 
	partywise_results;

--Seats Won by NDA Allianz Parties

SELECT 
	party as Party_Name,
	won as Seats_won
from 
	partywise_results
WHERE
	party IN(
				'Bharatiya Janata Party - BJP', 
                'Telugu Desam - TDP', 
				'Janata Dal  (United) - JD(U)',
                'Shiv Sena - SHS', 
                'AJSU Party - AJSUP', 
                'Apna Dal (Soneylal) - ADAL', 
                'Asom Gana Parishad - AGP',
                'Hindustani Awam Morcha (Secular) - HAMS', 
                'Janasena Party - JnP', 
				'Janata Dal  (Secular) - JD(S)',
                'Lok Janshakti Party(Ram Vilas) - LJPRV', 
                'Nationalist Congress Party - NCP',
                'Rashtriya Lok Dal - RLD', 
                'Sikkim Krantikari Morcha - SKM'

				)
		ORDER BY Seats_won DESC;
			
--	Total Seats Won by I.N.D.I.A.(Indian National Developmental Inclusive Alliance) Allianz

SELECT 
		SUM(CASE 
		when party IN(
				'Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK'
			)
			THEN won
			ELSE 0
			end) as INDIA_Alliance_Seats_won
			from partywise_results;

----Seats Won by INDIA Allianz Parties

SELECT 
		party As Party_Name,
		won AS Seats_won
	FROM
		partywise_results
	WHERE party IN(
				'Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK'
			)
			ORDER BY Seats_won DESC;


--Add new column field in table partywise_results to get the Party Allianz as NDA, I.N.D.I.A and OTHER

SELECT * FROM partywise_results;

ALTER TABLE partywise_results
ADD Party_Alliance VARCHAR(50);

SELECT * FROM partywise_results;

--I.N.D.I.A. 


UPDATE partywise_results
SET Party_Alliance = 'I.N.D.I.A.'
WHERE party in (
				'Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK'
			);
			
SELECT party,won 
	FROM partywise_results
where Party_Alliance = 'I.N.D.I.A.'
ORDER BY won DESC;

SELECT * FROM partywise_results;

-- NDA

UPDATE partywise_results
SET Party_Alliance = 'NDA'
WHERE party IN ('Bharatiya Janata Party - BJP', 
                'Telugu Desam - TDP', 
				'Janata Dal  (United) - JD(U)',
                'Shiv Sena - SHS', 
                'AJSU Party - AJSUP', 
                'Apna Dal (Soneylal) - ADAL', 
                'Asom Gana Parishad - AGP',
                'Hindustani Awam Morcha (Secular) - HAMS', 
                'Janasena Party - JnP', 
				'Janata Dal  (Secular) - JD(S)',
                'Lok Janshakti Party(Ram Vilas) - LJPRV', 
                'Nationalist Congress Party - NCP',
                'Rashtriya Lok Dal - RLD', 
                'Sikkim Krantikari Morcha - SKM'
)
SELECT * FROM partywise_results;

SELECT party,won 
	FROM partywise_results
where Party_Alliance = 'NDA'
ORDER BY won DESC;

--OTHER


UPDATE partywise_results
set Party_Alliance = 'OTHER'
where Party_Alliance IS NULL;

SELECT party,won 
	FROM partywise_results
where Party_Alliance = 'OTHER'
ORDER BY won DESC;

SELECT * FROM partywise_results;

--Which party alliance (NDA, I.N.D.I.A, or OTHER) won the most seats across all states?

SELECT 
		p.Party_Alliance,
	count(cr.constituency_ID) as seats_won
from 
	constituencywise_results cr
	JOIN 
			partywise_results p on cr.Party_ID = p. Party_ID
	where 
			p.Party_Alliance IN ('NDA','I.N.D.I.A.','OTHER')
	GROUP BY 
			p.Party_Alliance 
	ORDER BY
			seats_won DESC;
	
--Winning candidate's name, their party name, total votes, and the margin of victory for a specific state and constituency?

	