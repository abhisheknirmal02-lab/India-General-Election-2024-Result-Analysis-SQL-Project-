-- ============================================================
--   India General Election 2024 — Result Analysis
--   Tool     : PostgreSQL / MySQL
--   Dataset  : Kaggle — India General Election 2024
--   Author   : Abhishek Nirmal
--   GitHub   : github.com/abhisheknirmal02-lab
-- ============================================================

-- ============================================================
-- SECTION 0 : DATABASE SCHEMA (Tables used in this project)
-- ============================================================
-- constituencywise_results  → Constituency-level winning data
-- constituencywise_details  → Candidate-level vote breakdown (EVM + Postal)
-- partywise_results         → Party-level seat tally  (+ Party_Alliance column added below)
-- statewise_results         → Maps constituencies to states
-- states                    → State master table (state_id, state name)

-- ============================================================
-- SECTION 1 : OVERALL SEAT COUNT
-- ============================================================

-- Q1. Total parliamentary seats contested
SELECT 
    COUNT(DISTINCT parliament_constituency) AS Total_Seats
FROM constituencywise_results;


-- Q2. Seats available per state
SELECT 
    s.states                              AS State_Name,
    COUNT(cr.parliament_constituency)     AS Total_Seats
FROM constituencywise_results cr
INNER JOIN statewise_results sr ON cr.parliament_constituency = sr.parliament_constituency
INNER JOIN states s             ON sr.state_id = s.state_id
GROUP BY s.states
ORDER BY Total_Seats DESC;


-- ============================================================
-- SECTION 2 : NDA ALLIANCE ANALYSIS
-- ============================================================

-- Q3. Total seats won by NDA Alliance
SELECT 
    SUM(CASE
            WHEN party IN (
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
            ) THEN won
            ELSE 0
        END) AS NDA_Total_Seats_Won
FROM partywise_results;


-- Q4. Seats won by each NDA party (ranked)
SELECT 
    party AS Party_Name,
    won   AS Seats_Won
FROM partywise_results
WHERE party IN (
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
ORDER BY Seats_Won DESC;


-- ============================================================
-- SECTION 3 : I.N.D.I.A. ALLIANCE ANALYSIS
-- ============================================================

-- Q5. Total seats won by I.N.D.I.A. Alliance
SELECT 
    SUM(CASE 
            WHEN party IN (
                'Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK'
            ) THEN won
            ELSE 0
        END) AS INDIA_Alliance_Seats_Won
FROM partywise_results;


-- Q6. Seats won by each I.N.D.I.A. party (ranked)
SELECT 
    party AS Party_Name,
    won   AS Seats_Won
FROM partywise_results
WHERE party IN (
    'Indian National Congress - INC',
    'Aam Aadmi Party - AAAP',
    'All India Trinamool Congress - AITC',
    'Bharat Adivasi Party - BHRTADVSIP',
    'Communist Party of India  (Marxist) - CPI(M)',
    'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
    'Communist Party of India - CPI',
    'Dravida Munnetra Kazhagam - DMK',
    'Indian Union Muslim League - IUML',
    'Jammu & Kashmir National Conference - JKN',
    'Jharkhand Mukti Morcha - JMM',
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
ORDER BY Seats_Won DESC;


-- ============================================================
-- SECTION 4 : ADD PARTY_ALLIANCE COLUMN  (run once)
-- ============================================================

-- Step 1 — Add column
ALTER TABLE partywise_results
ADD Party_Alliance VARCHAR(50);

-- Step 2 — Tag I.N.D.I.A. parties
UPDATE partywise_results
SET Party_Alliance = 'I.N.D.I.A.'
WHERE party IN (
    'Indian National Congress - INC',
    'Aam Aadmi Party - AAAP',
    'All India Trinamool Congress - AITC',
    'Bharat Adivasi Party - BHRTADVSIP',
    'Communist Party of India  (Marxist) - CPI(M)',
    'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
    'Communist Party of India - CPI',
    'Dravida Munnetra Kazhagam - DMK',
    'Indian Union Muslim League - IUML',
    'Jammu & Kashmir National Conference - JKN',
    'Jharkhand Mukti Morcha - JMM',
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

-- Step 3 — Tag NDA parties
UPDATE partywise_results
SET Party_Alliance = 'NDA'
WHERE party IN (
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
);

-- Step 4 — Tag remaining parties as OTHER
UPDATE partywise_results
SET Party_Alliance = 'OTHER'
WHERE Party_Alliance IS NULL;


-- ============================================================
-- SECTION 5 : ALLIANCE vs ALLIANCE COMPARISON
-- ============================================================

-- Q7. Which alliance won the most seats overall?
SELECT 
    p.Party_Alliance,
    COUNT(cr.constituency_id) AS Seats_Won
FROM constituencywise_results cr
JOIN partywise_results p ON cr.party_id = p.party_id
WHERE p.Party_Alliance IN ('NDA', 'I.N.D.I.A.', 'OTHER')
GROUP BY p.Party_Alliance
ORDER BY Seats_Won DESC;


-- Q8. State-wise seat split: NDA vs I.N.D.I.A. vs OTHER
SELECT
    s.states                                                              AS State_Name,
    SUM(CASE WHEN p.Party_Alliance = 'NDA'       THEN 1 ELSE 0 END)     AS NDA_Seats_Won,
    SUM(CASE WHEN p.Party_Alliance = 'I.N.D.I.A.' THEN 1 ELSE 0 END)   AS INDIA_Seats_Won,
    SUM(CASE WHEN p.Party_Alliance = 'OTHER'     THEN 1 ELSE 0 END)     AS OTHER_Seats_Won
FROM constituencywise_results cr
JOIN partywise_results p   ON cr.party_id = p.party_id
JOIN statewise_results sr  ON cr.parliament_constituency = sr.parliament_constituency
JOIN states s              ON sr.state_id = s.state_id
WHERE p.Party_Alliance IN ('NDA', 'I.N.D.I.A.', 'OTHER')
GROUP BY s.states
ORDER BY s.states;


-- ============================================================
-- SECTION 6 : CONSTITUENCY-LEVEL DEEP DIVES
-- ============================================================

-- Q9. Winning candidate details — party, votes & margin
--     (Example filter: Shiv Sena wins in Maharashtra)
SELECT
    cr.winning_candidate,
    pr.party,
    pr.Party_Alliance,
    cr.total_votes,
    cr.margin,
    s.states,
    cr.constituency_name
FROM constituencywise_results cr
INNER JOIN partywise_results pr  ON cr.party_id = pr.party_id
INNER JOIN statewise_results sr  ON cr.parliament_constituency = sr.parliament_constituency
INNER JOIN states s              ON sr.state_id = s.state_id
WHERE pr.Party_Alliance = 'NDA'
  AND pr.party          = 'Shiv Sena - SHS'
  AND s.states          = 'Maharashtra';


-- Q10. EVM votes vs Postal votes per candidate in a constituency
--      (Example filter: BJP candidates in Uttar Pradesh)
SELECT
    cd.candidate,
    cd.party,
    cd.evm_votes,
    cd.postal_votes,
    cd.evm_votes + cd.postal_votes AS Total_Votes,
    s.states,
    cr.constituency_name
FROM constituencywise_details cd
JOIN constituencywise_results cr  ON cd.constituency_id = cr.constituency_id
INNER JOIN statewise_results sr   ON cr.parliament_constituency = sr.parliament_constituency
INNER JOIN states s               ON sr.state_id = s.state_id
WHERE cd.party = 'Bharatiya Janata Party - BJP'
  AND s.states = 'Uttar Pradesh';


-- Q11. Parties with most seats in a specific state
--      (Example filter: Bihar)
SELECT 
    p.party                       AS Party_Name,
    COUNT(cr.constituency_id)     AS Seats_Won
FROM constituencywise_results cr
JOIN partywise_results p   ON cr.party_id = p.party_id
JOIN statewise_results sr  ON cr.parliament_constituency = sr.parliament_constituency
JOIN states s              ON sr.state_id = s.state_id
WHERE s.states = 'Bihar'
GROUP BY p.party
ORDER BY Seats_Won DESC;


-- Q12. Top 10 constituencies by highest EVM votes (leading candidate)
SELECT
    cr.constituency_name,
    cd.constituency_id,
    cd.candidate,
    cd.evm_votes
FROM constituencywise_details cd
JOIN constituencywise_results cr ON cd.constituency_id = cr.constituency_id
WHERE cd.evm_votes = (
    SELECT MAX(cd1.evm_votes)
    FROM constituencywise_details cd1
    WHERE cd1.constituency_id = cd.constituency_id
)
ORDER BY cd.evm_votes DESC
LIMIT 10;


-- Q13. Winner & runner-up in each constituency of a state (CTE)
--      (Example filter: Maharashtra)
WITH RankedCandidates AS (
    SELECT
        cd.candidate,
        cd.constituency_id,
        cd.party,
        cd.evm_votes,
        cd.postal_votes,
        cd.evm_votes + cd.postal_votes                                          AS Total_Votes,
        ROW_NUMBER() OVER (
            PARTITION BY cd.constituency_id
            ORDER BY cd.evm_votes + cd.postal_votes DESC
        )                                                                        AS VoteRank
    FROM constituencywise_details cd
    JOIN constituencywise_results cr ON cd.constituency_id = cr.constituency_id
    JOIN statewise_results sr        ON sr.parliament_constituency = cr.parliament_constituency
    JOIN states s                    ON sr.state_id = s.state_id
    WHERE s.states = 'Maharashtra'
)
SELECT 
    cr.constituency_name,
    MAX(CASE WHEN rc.VoteRank = 1 THEN rc.candidate END) AS Winning_Candidate,
    MAX(CASE WHEN rc.VoteRank = 2 THEN rc.candidate END) AS Runnerup_Candidate
FROM RankedCandidates rc
JOIN constituencywise_results cr ON rc.constituency_id = cr.constituency_id
GROUP BY cr.constituency_name
ORDER BY cr.constituency_name;


-- ============================================================
-- SECTION 7 : STATE SUMMARY STATISTICS
-- ============================================================

-- Q14. Maharashtra — full election summary
--      (seats, candidates, parties, total votes, EVM vs Postal)
SELECT
    COUNT(DISTINCT cr.constituency_id)              AS Total_Seats,
    COUNT(DISTINCT cd.candidate)                    AS Total_Candidates,
    COUNT(DISTINCT pr.party)                        AS Total_Parties,
    SUM(cd.evm_votes + cd.postal_votes)             AS Total_Votes,
    SUM(cd.evm_votes)                               AS Total_EVM_Votes,
    SUM(cd.postal_votes)                            AS Total_Postal_Votes
FROM constituencywise_results cr
JOIN constituencywise_details cd ON cr.constituency_id = cd.constituency_id
JOIN statewise_results sr        ON cr.parliament_constituency = sr.parliament_constituency
JOIN states s                    ON s.state_id = sr.state_id
JOIN partywise_results pr        ON pr.party_id = cr.party_id
WHERE s.states = 'Maharashtra';
