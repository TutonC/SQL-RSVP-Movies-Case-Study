# 🎬 RSVP Movies – SQL Case Study (IMDb Data Analysis)

## 📌 Project Overview
RSVP Movies is an Indian film production company planning to release a movie for a **global audience**.  
This project analyzes **IMDb movie data from the past three years** using **SQL** to derive insights that support strategic decision-making for the upcoming project.

The analysis focuses on genres, ratings, production houses, directors, and actors to recommend an optimal combination for global success.

---

## 🎯 Business Objectives
- Identify the **top-performing genres** based on movie volume and ratings  
- Determine the **optimal movie duration** for audience engagement  
- Rank **production houses** based on consistent success  
- Recommend **directors, actors, and actresses** using ratings and vote-based metrics  
- Evaluate **regional vs global appeal** of talent and studios  

---

## 🗂 Dataset Description
The analysis uses a relational IMDb dataset with the following tables:
- `movie`
- `ratings`
- `genre`
- `names`
- `role_mapping`
- `director_mapping`

---

## 🛠 Tools & Technologies
- SQL (MySQL-compatible syntax)
- Common Table Expressions (CTEs)
- Window Functions (`RANK`, `DENSE_RANK`, `ROW_NUMBER`)
- Aggregate Functions
- Joins & Subqueries

---

## 📊 Key Insights & Recommendations
- **Drama** is the most dominant genre, indicating strong audience demand  
- Well-rated movies average around **107 minutes**, suggesting optimal runtime  
- **Dream Warrior Pictures** and **National Theatre Live** are the top-performing production houses  
- **James Mangold** is the most reliable director based on average ratings  
- **Mammootty** and **Mohanlal** are recommended actors  
- **Taapsee Pannu** emerges as the strongest actress based on ratings and votes  
- **Vijay Sethupathi** is recommended for regional appeal  
- For global reach, collaboration with **Marvel Studios, Warner Bros., or 20th Century Fox** is advised  

---

## 📁 Repository Structure
