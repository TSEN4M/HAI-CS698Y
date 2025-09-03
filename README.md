# Student Dropout Prediction — Fairness & Bias

## Project Overview

This project predicts Graduate (1) vs Dropout (0) on the UCI "Predict Students’ Dropout and Academic Success" dataset, focusing on fairness by **Gender** (0 = Male, 1 = Female). The notebook performs a pre-training bias audit, trains a baseline model, applies bias mitigations, and compares utility and fairness before vs after mitigation using **Statistical Parity Difference (SPD)** and **Equal Opportunity Difference (EOD)**.

---

## Project Structure

- `student_dropout_fairness.ipynb`: EDA, bias audit, models, mitigations, evaluation
- `data.csv`: Dataset (UCI "Predict Students’ Dropout and Academic Success")
- `metrics_comparison.csv`: Metrics summary saved by the notebook
- `requirements.txt`: Python dependencies
- `Dockerfile`: JupyterLab container for reproducibility
- `README.md`: This file

---

## Data

Place the dataset at `data.csv` in the project root (the notebook loads this path by default).

- **Target mapping:** Graduate → 1, Dropout → 0 (we exclude “Enrolled” from modeling)
- **Protected attribute:** Gender (0 = Male, 1 = Female)
- To use a different path, update `csv_path` in Section 2 of the notebook.

---

## Quick Start (Local)

Create and activate a Python environment, then install dependencies:

```bash
python -m venv .venv

# Windows
.venv\Scripts\activate

# macOS/Linux
source .venv/bin/activate

pip install -r requirements.txt

```

Open `student_dropout_fairness.ipynb` and run the cells from top to bottom.

---

## Quick Start (Docker)

```bash
#Build the Docker image:

docker build -t dropout-fairness .

#Run JupyterLab container:

docker run --rm -it -p 8888:8888 dropout-fairness

Open your browser at [http://localhost:8888/lab](http://localhost:8888/lab) and load `student_dropout_fairness.ipynb`.


docker run --rm -it -p 8888:8888 -v "$PWD":/app dropout-fairness
```

---

## What the Notebook Does

- **Bias audit (pre-model):**

  - Representation of gender groups
  - Base rates: probability of graduation per gender
  - Intersectional check: Gender × Scholarship status
  - Timing/labeler signal analysis (Enrolled share by gender)
  - Data quality: missingness, duplicates, skew

- **Modeling:**

  - Baseline logistic regression model (includes Gender)
  - **Mitigations:**
    - A: Drop Gender feature (kept for fairness analysis)
    - B: Reweighting using Kamiran–Calders A×Y method
    - C: Calibration (Isotonic regression) on No-Gender model

- **Evaluation:**
  - Overall utility metrics: Accuracy, Precision, Recall, F1, ROC-AUC
  - Fairness metrics: SPD & EOD (Female minus Male)
  - Per-group utility (Male vs Female)
  - Before/after mitigation comparison
  - Saves results summary to `metrics_comparison.csv`

---

## Evaluation Metrics

- **Utility:**

  - Accuracy, Precision, Recall, F1-Score, ROC-AUC

- **Fairness (Female − Male):**
  - **SPD (Statistical Parity Difference):** $P(\hat{y}=1 \mid \text{Female}) - P(\hat{y}=1 \mid \text{Male})$ — selection parity
  - **EOD (Equal Opportunity Difference):** $TPR_{\text{Female}} - TPR_{\text{Male}}$ — primary metric since graduation is beneficial

_Negative SPD or EOD values indicate worse outcomes for female students._

---

## Results (Latest Run)

| Model                     | Accuracy | Precision | Recall | F1    | SPD    | EOD    |
| ------------------------- | -------- | --------- | ------ | ----- | ------ | ------ |
| Baseline (with Gender)    | 0.753    | 0.756     | 0.878  | 0.812 | -0.375 | -0.265 |
| Mitigation A — No-Gender  | 0.741    | 0.737     | 0.893  | 0.808 | -0.169 | -0.091 |
| Mitigation B — Reweighted | 0.745    | 0.734     | 0.910  | 0.813 | -0.113 | -0.017 |
| Mitigation C — Calibrated | 0.752    | 0.757     | 0.873  | 0.811 | -0.193 | -0.106 |

---

## Key Takeaways

- The **Baseline model** has strong F1 but large gender disparities reflecting historical gaps.
- **Mitigation A (No-Gender model)** significantly improves fairness with minimal utility loss.
- **Mitigation B (Reweighting)** achieves the best equal opportunity (lowest EOD) and highest female F1 score, comparable to baseline utility.
- **Mitigation C (Calibration)** improves probability quality with fairness close to Mitigation A.

The notebook also visualizes confusion matrices, ROC curves, and subgroup tables.

---

## Reproducibility

- Library versions printed in Section 1 of the notebook.
- Fixed random seed with stratified splits by Target × Gender.
- Running the notebook regenerates metrics and figures.

---

## Notes & Acknowledgments

- Dataset from UCI ML Repository: "Predict Students’ Dropout and Academic Success".
- Fairness framing focuses on Equal Opportunity as graduation is a beneficial outcome.

---

## Contributors

- Tsewang Namgail (241110093)

  - Data exploration and bias evaluation
  - Implementation of mitigation B (Reweighting) and mitigation C (Calibration)
  - Evaluation and results analysis (50%)
  - README and code documentation

- Sevak Shekokar (241110065)

  - Data exploration and bias evaluation
  - Implementation of baseline model and mitigation A (Drop Gender)
  - Evaluation and results analysis
  - Dockerfile and code documentation

Both Tsewang Namgail and Sevak Shekokar has contributed equally across the major components of the project, collaborating on data analysis, modeling, fairness mitigations, evaluation, and documentation.

---
