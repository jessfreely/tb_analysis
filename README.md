# U.S. Tuberculosis Surveillance Data Analysis (1993 - 2023)

## Project Overview
This repository contains an exploratory data analysis (EDA) of United States Tuberculosis (TB) surveillance data. 

## Data Source
The dataset was extracted from the **CDC WONDER Online Tuberculosis Information System (OTIS)**. It includes data on TB case counts, population estimates, and calculated incidence rates across all 50 U.S. states and territories from 1993 to 2023.

## Analytical Approach & Epidemiological Logic
This analysis applies descriptive epidemiology principles to evaluate trends across time and place:
* National case data is aggregated to calculate longitudinal national incidence rates per 100,000 population.
* Geographic Burden (Volume vs. Risk): State-level data is analyzed using two distinct methods:
  1. Average Annual Incidence Rate: Adjusts for population differences to show per capita transmission risk.
  2. Average Annual Case Count: Ignores population size to show total physical disease volume.

## Key Technical Skills Demonstrated
* Data Cleaning & Wrangling (`tidyverse`, `dplyr`): Filtering out footers from CDC text downloads, handling missing data (`na.rm = TRUE`), and parsing data types.
* Data Visualization (`ggplot2`, `patchwork`): Generating line plots and comparative bar layouts to contrast metrics side-by-side.

## How to Run This Project
1. Clone this repository.
2. Ensure you have the `tidyverse`, `lubridate`, and `patchwork` packages installed in R.
3. Open the `.Rproj` file to set your working directory automatically.
4. Run the script to generate the combined surveillance visual.
