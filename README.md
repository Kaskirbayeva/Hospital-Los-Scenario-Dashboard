# Hospital LOS Scenario Dashboard

## Overview

The Hospital LOS Scenario Dashboard is an interactive R Shiny application that demonstrates how machine learning can support hospital resource planning through scenario analysis. Rather than predicting the length of stay (LOS) for a single patient, the dashboard allows users to evaluate **"what-if" scenarios** by modifying the characteristics of a representative patient cohort.


The dashboard illustrates how changes in patient case-mix may influence predicted LOS distribution, bed occupancy, and hospital resource requirements.


## Features

* Interactive scenario analysis using representative patient cohorts.
* Integration of the best-performing machine learning model.
* Adjustable patient and hospital characteristics, including:

  * Emergency admissions
  * Elective admissions
  * Older patients (≥65 years)
  * Hospital characteristics (where applicable)
* Prediction of LOS category for the modified cohort.
* Estimation of:

  * LOS category distribution
  * Expected bed-days
  * Bed occupancy
  * Resource requirements
* Comparison of baseline and user-defined scenarios.
* Interactive visualizations and downloadable results.



## Workflow

1. Load a representative patient cohort.
2. Modify cohort characteristics according to the selected scenario.
3. Apply the trained machine learning model to predict LOS categories.
4. Aggregate predictions into operational metrics.
5. Display results through interactive tables and visualizations.



## Repository Structure

```text
Hospital-LOS-Scenario-Dashboard/

├── app.R
├── README.md
├── LICENSE
├── data/
│   ├── cohort.rds
│   └── variable_levels.rds
├── models/
│   └── rf_final.rds
├── R/
│   ├── prediction.R
│   ├── scenario.R
│   ├── plots.R
│   └── helpers.R
├── www/
│   └── style.css
└── figures/
```



## Requirements

* R (version 4.3 or later recommended)
* RStudio (recommended)

### Required R packages

* shiny
* bslib
* dplyr
* tidyr
* ggplot2
* plotly
* DT
* ranger
* randomForest
* pROC
* shinyWidgets

Additional packages may be required depending on the machine learning model used.



## Running the Application

Clone the repository:

```bash
git clone https://github.com/<username>/hospital-los-scenario-dashboard.git
```

Open `app.R` in RStudio and run:

```r
shiny::runApp()
```

Alternatively, from the project directory:

```r
shiny::runApp()
```


## Data Availability

The original hospital episode data used to develop the prediction models are not publicly available because they contain confidential patient information and are subject to data governance restrictions.

This repository therefore includes only:

* synthetic datasets for demonstration purposes;
* the complete source code for the dashboard.


## Disclaimer

This dashboard is intended as a research demonstration and proof of concept. It is not a certified clinical decision-support system and should not be used as the sole basis for clinical or operational decisions.


## Citation

TBU


## License

This project is released under the MIT License. See the `LICENSE` file for details.



## Contact

Dr Daliya Kaskirbayeva

Astana, Kazakhstan

For questions, suggestions, or collaboration opportunities, please open an issue in this repository.
