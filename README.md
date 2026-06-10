# 🗳️ India General Election 2024 — SQL Result Analysis

> A structured SQL project analysing the results of India's 18th Lok Sabha General Election (2024) across 543 constituencies, 28 states + 8 UTs, and three major political alliances — NDA, I.N.D.I.A., and OTHER.

---

## 📌 Project Overview

The 2024 Indian General Election was one of the largest democratic exercises in human history, with over 960 million eligible voters. This project digs into the results using SQL — exploring seat distributions, alliance-level performance, constituency-level margins, EVM vs Postal vote splits, and state-level summaries.

**No BI tool. Just SQL doing the heavy lifting.**

---

## 🗂️ Dataset

| Source | Kaggle — India General Election 2024 Results |
|---|---|
| Format | Relational (5 tables) |
| Coverage | All 543 Lok Sabha constituencies |

### Tables Used

| Table | Description |
|---|---|
| `constituencywise_results` | Constituency-level winners, total votes, and margin of victory |
| `constituencywise_details` | Candidate-level vote breakdown (EVM + Postal votes) |
| `partywise_results` | Party-level seat tally; `Party_Alliance` column added via `ALTER TABLE` |
| `statewise_results` | Maps each constituency to its state |
| `states` | State master table (state_id → state name) |

---

## 🧩 SQL Concepts Used

- `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`
- `INNER JOIN` across multiple tables
- `CASE WHEN` for conditional aggregation
- `ALTER TABLE` + `UPDATE` for schema enrichment (adding `Party_Alliance`)
- **Subqueries** — correlated subquery to find max EVM votes per constituency
- **CTEs** (`WITH`) — ranking candidates using `ROW_NUMBER() OVER (PARTITION BY ...)`
- `SUM`, `COUNT`, `MAX`, `DISTINCT`
- `LIMIT` for top-N results

---

## 📋 Business Questions Answered

### 🏛️ Overall Seat Analysis
| # | Question |
|---|---|
| Q1 | How many total parliamentary seats were contested? |
| Q2 | How many seats were available per state? |

### 🟠 NDA Alliance
| # | Question |
|---|---|
| Q3 | What was the total seats won by the NDA alliance? |
| Q4 | How many seats did each NDA party win individually? |

### 🔵 I.N.D.I.A. Alliance
| # | Question |
|---|---|
| Q5 | What was the total seats won by the I.N.D.I.A. alliance? |
| Q6 | How many seats did each I.N.D.I.A. party win individually? |

### ⚔️ Alliance vs Alliance
| # | Question |
|---|---|
| Q7 | Which alliance won the most seats nationally? |
| Q8 | State-wise seat split between NDA, I.N.D.I.A., and OTHER |

### 🗺️ Constituency Deep Dives
| # | Question |
|---|---|
| Q9 | Winning candidate name, party, votes, and victory margin per constituency |
| Q10 | EVM votes vs Postal votes breakdown per candidate |
| Q11 | Which parties won the most seats in a given state? (Bihar example) |
| Q12 | Top 10 constituencies with the highest EVM votes (leading candidate) |
| Q13 | Winner and runner-up in each constituency of a state (Maharashtra, using CTE + Window Function) |

### 📊 State Summary
| # | Question |
|---|---|
| Q14 | Maharashtra full election summary — seats, candidates, parties, total votes, EVM vs Postal split |

---

## 🗃️ Schema Diagram

```
states
  └── state_id (PK)
  └── states

statewise_results
  └── parliament_constituency (FK → constituencywise_results)
  └── state_id (FK → states)

constituencywise_results
  └── constituency_id (PK)
  └── parliament_constituency
  └── party_id (FK → partywise_results)
  └── winning_candidate, total_votes, margin, constituency_name

constituencywise_details
  └── constituency_id (FK → constituencywise_results)
  └── candidate, party, evm_votes, postal_votes, total_votes

partywise_results
  └── party_id (PK)
  └── party, won
  └── Party_Alliance  ← added via ALTER TABLE (NDA / I.N.D.I.A. / OTHER)
```

---

## 🔍 Sample Query — Winner & Runner-Up per Constituency (Maharashtra)

```sql
WITH RankedCandidates AS (
    SELECT
        cd.candidate,
        cd.constituency_id,
        cd.evm_votes + cd.postal_votes AS Total_Votes,
        ROW_NUMBER() OVER (
            PARTITION BY cd.constituency_id
            ORDER BY cd.evm_votes + cd.postal_votes DESC
        ) AS VoteRank
    FROM constituencywise_details cd
    JOIN constituencywise_results cr ON cd.constituency_id = cr.constituency_id
    JOIN statewise_results sr ON sr.parliament_constituency = cr.parliament_constituency
    JOIN states s ON sr.state_id = s.state_id
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
```

---

## 🚀 How to Run

1. Import the dataset into PostgreSQL or MySQL
2. Run `SECTION 4` of the SQL file first — this adds the `Party_Alliance` column to `partywise_results` (required for all alliance-related queries)
3. Run individual queries from any section in any order after that

---

## 📁 File Structure

📄 [India_General_Election_2024.sql](https://github.com/abhisheknirmal02-lab/India-General-Election-2024-Result-Analysis-SQL-Project-/blob/main/India_General_Election_2024.sql) — All 14 queries, organized into 7 sections  
📋 [Indian General Election 2024 Result Analysis SQL project.docx](https://github.com/abhisheknirmal02-lab/India-General-Election-2024-Result-Analysis-SQL-Project-/blob/main/Indian%20General%20Election%202024%20Result%20Analysis%20SQL%20project.docx) — Query results with screenshots  
📝 README.md — Project documentation

---

## 💡 Key Findings

- **543 total seats** were contested across India
- **NDA** emerged as the largest alliance by seat count
- **Maharashtra** alone had 48 constituencies — the highest of any state
- The **CTE + Window Function** approach (Q13) cleanly identifies winners and runners-up without any self-join complexity
- **EVM vs Postal vote** analysis (Q10) highlights how marginal postal votes can be in high-turnout urban constituencies

---

## 🛠️ Tools

- **SQL** (PostgreSQL / MySQL compatible)
- Dataset sourced from **Kaggle**

---

## 👤 Author

**Abhishek Nirmal**  
Aspiring Data Analyst | Power BI · SQL · Python · Advanced Excel  
📎 [GitHub](https://github.com/abhisheknirmal02-lab) | [LinkedIn](https://www.linkedin.com/in/abhishek-nirmal-3b6325370/)

---

*Feel free to fork, use, and build on this project. If you find it useful, a ⭐ would mean a lot!*
