# Customer-Segmentation-RFM-Analysis
Customer segmentation project using SQL and Power BI to analyze user loyalty and value through the RFM (Recency, Frequency, Monetary) model.
# 📊 Customer Segmentation | RFM Analysis

## 📌 Project Overview
This project focuses on segmenting a customer base of **2,000 clients** to optimize marketing strategies. By applying the **RFM Model**, I identified key customer groups based on their purchasing behavior, analyzing a total revenue of **$107M**.

## 🖼 Dashboard Preview
![RFM Dashboard](вставь_сюда_ссылку_на_свой_скриншот)

## 🛠 Tech Stack
* **SQL:** Data cleaning, transaction aggregation, and scoring using `NTILE` functions.
* **Power BI:** Data visualization and interactive reporting.
* **DAX:** Calculated measures for revenue shares, average order values, and the RFM Index.

## 📈 Key Business Insights
* **Revenue Concentration:** The **High Value** segment represents only **17.82%** of the customer base but generates **43.75%** of total revenue ($47M).
* **Growth Opportunity:** The largest group is **Needing Attention (21.91%)**. These are customers who haven't purchased recently but have good potential.
* **Risk Management:** Segments like **At Risk** and **Slipping Away** account for approximately **$16M** in revenue. Retention campaigns are prioritized for these groups.

## 🔍 Scoring Legend (Model Validation)
The scoring system is validated by clear differences in average metrics across scores:
* **Recency:** Score 5 reflects an average of **3.7 days** since the last purchase.
* **Frequency:** Top-tier customers (Score 5) average **2.3 orders**.
* **Monetary:** The average LTV for Score 5 customers is **$137K**.

## 💡 Strategic Recommendations
* **VIP & High Value:** Implement a VIP loyalty program with exclusive offers.
* **Needing Attention:** Launch re-engagement email campaigns with personalized discounts.
* **At Risk:** Conduct satisfaction surveys and offer "we miss you" incentives to prevent churn.
