# Churn_Analysis_Assignment-
Customer churn analysis &amp; prediction model for telecom dataset. Includes SQL, Python, visualizations, and strategic recommendations.


**📌 Overview**

This project analyzes customer churn data to identify the main factors driving churn and to build a simple churn prediction model. The work is divided into four tasks:

**Step_1: Data Preparation** – Cleaning and preparing the dataset.

**Step_2: Exploratory Analysis** – Creating meaningful visualizations to understand churn patterns.

**Step_3: Predictive Modeling** – Building a basic model to predict customer churn.

**Step_4: Strategic Recommendations** – Turning findings into actionable business steps.

The analysis combines both business insights **(why customers leave)** and technical methods **(how we can predict churn)**.


**🔑 Key Assumptions**

The dataset used is Telco Customer Churn (public dataset).

The target variable is Churn (Yes = customer left, No = customer stayed).

Categorical features are label-encoded before modeling.

A basic Logistic Regression model was used for prediction to keep it simple and interpretable.

Business recommendations are based only on data patterns found in the dataset (not on external market data).


**🚀 Steps to Run**

1.**Pre-requisites:**
pip install pandas numpy matplotlib seaborn scikit-learn

2.**Clone the repository:**
git clone https://github.com/Amrit-111/Churn_Analysis_Assignment-

3.**Open the Jupyter Notebook:**
jupyter notebook notebooks/python_analysis.ipynb

4.Run cells step by step to reproduce results.



**⚡ Challenges & How That Were Addressed**

Imbalanced Data → Churned customers were fewer compared to non-churn. To handle this, we focused on churn rate (%) comparisons and kept the model simple.

Feature Overlap → Some variables (like InternetService, TechSupport, etc.) were correlated. We used logistic regression for interpretability rather than complex models.

Visualization Clarity → For numeric features, histograms were confusing. We used KDE (density plots) to make trends clearer.

Time Constraint → Kept modeling basic (Logistic Regression) to balance between accuracy and simplicity.



