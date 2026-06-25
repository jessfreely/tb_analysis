library(tidyverse)
library(ggplot2)
library(dplyr)

# 1. Read the file
raw_tb_data <- read_csv("tb_analysis.csv")

# 2. Clean it up
clean_tb_data <- raw_tb_data %>%
  
  # Drop the text comments at the bottom and the "Total" rows
  filter(is.na(Notes)) %>%
  
  # Drop the empty Notes column and the broken, empty Population column
  select(-Notes, -Population) %>%
  
  # Rename the columns
  rename(
    incidence_rate = `Rate per 100`,
    state_population = `000`
  ) %>%
  
  # Make the Year numeric so it graphs correctly
  mutate(Year = as.numeric(Year))


# 3. Use clean data to get national numbers by year
national_trends <- clean_tb_data %>%
  group_by(Year) %>%
  summarize(
    total_cases = sum(Cases, na.rm = TRUE),
    total_pop = sum(state_population, na.rm = TRUE),
    # Calculate the national rate per 100000 population
    national_rate = (total_cases / total_pop) * 100000,
    .groups = "drop"
  )

# 4. Build the ggplot
ggplot(data = national_trends, aes(x = Year, y = national_rate)) +
  # Add a trend line
  geom_line(color = "darkblue", linewidth = 1) + 
  
  # Add data points on the line
  geom_point(color = "darkblue", size = 2) + 
  
  # Clean up the scales
  scale_x_continuous(breaks = seq(1993, 2023, by = 5)) +
  
  # Labels 
  labs(
    title = "U.S. Tuberculosis Incidence Rate Trends (1993 to 2023)",
    subtitle = "Data Source CDC WONDER OTIS TB Surveillance System",
    x = "Year",
    y = "Incidence Rate per 100,000 Population"
  ) +
  theme_minimal(base_size = 12) 

