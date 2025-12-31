# Demographics of Time Poverty: An Analysis of Gender Disparity and Temporal Stability in U.S. Time Use (2020–2024)

[![Paper](https://img.shields.io/badge/Paper-PDF-blue)](paper/Demographics-of-Time-Poverty.pdf) [![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

## Abstract

*This study assesses the gender disparity and temporal stability of time poverty using five years of pooled data (2020–2024) from the American Time Use Survey [(ATUS)](https://www.bls.gov/tus/). Time-poverty is rigorously defined as the intersection of insufficient time for necessary self-maintenance (Personal Care) and discretionary enjoyment (Leisure Time), quantified by the 25th percentile of each distribution. Pearson’s χ2 test and the Mantel-Haenszel (MH) test were employed to evaluate the hypotheses. Results show no statistically significant change in the absolute prevalence of time-poverty over the 2020–2024 period (χ2 = 3.25,p = 0.5176). However, a highly significant gender disparity exists, with the odds of a male being time-poor being 21.1% lower than for a female (Common OR =0.789; 95% CI: 0.733–0.850). These findings establish that time poverty is a stable, gendered phenomenon during this period.*

## Paper

- **[Full Paper (PDF)](paper/Demographics-of-Time-Poverty.pdf)**

---

## Data

This study uses data from the **American Time Use Survey [(ATUS)](https://www.bls.gov/tus/)**.

* **Source**: U.S. Bureau of Labor Statistics (via [IPUMS ATUS](https://www.atusdata.org/atus/))
* **Description**: ATUS provides nationally representative data on how individuals in the United States allocate their time across daily activities.
* **Access**: Data were processed using the `ipumsr` R package.

> **Note**: Users wishing to reproduce the analysis must obtain ATUS data directly from IPUMS and comply with their data use agreement.

---

## Code Artifact

The `code/` directory contains all scripts used for data cleaning, analysis, and result generation.

### Programming Language

* **R**

### Required R Libraries

The following R packages are required to run the code:

* **ipumsr** — for reading and processing IPUMS ATUS extracts
* **dplyr** — for data manipulation and transformation
* **janitor** — for data cleaning and variable name standardization

You can install the required libraries using:

```r
install.packages(c("ipumsr", "dplyr", "janitor"))
```

### Reproducibility Notes

* Code was developed and tested using standard R environments.
* File paths and data locations may need to be updated depending on your local setup.

---

## File Structure

```text
demographics-of-time-poverty/
├─ README.md           										# This document
├─ LICENSE             										# MIT — applies to code
├─ LICENSE-CC-BY-4.0         								# CC BY 4.0 — applies to paper and non-code
├─ CITATION.cff         									# Citation metadata
├─ paper/
│  ├─ Demographics-of-Time-Poverty.pdf   					# Full paper
├─ code/               										# Analysis scripts
│  ├─ gender_timepoverty_association_chi2_test.r
│  ├─ stratified_gender_timepoverty_mh_test.r
│  ├─ timepoverty_prevalence_trend_over_years_chi2_test.r
```

---

## License

* **Paper and documentation**: Creative Commons Attribution 4.0 International [(CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/)
* **Code**: MIT License

---
