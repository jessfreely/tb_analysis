library(tidyverse)
library(ggplot2)
library(dplyr)
library(patchwork)

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

# 5. Show which states are driving the national trends
state_trends <- clean_tb_data %>%
  group_by(State) %>%
  summarize(
    avg_cases = mean(Cases, na.rm = TRUE),
    avg_rate  = mean(incidence_rate, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_rate)) %>%
  slice_head(n = 10) 
# Grab the top 10 highest-burden states

# 6. Bar Charts
plot_rates <- ggplot(state_trends, aes(x = reorder(State, avg_rate), y = avg_rate)) +
  geom_col(fill = "steelblue") +
  coord_flip() + 
  labs(
    title = "Top 10 States with Highest Average TB Incidence Rates",
    x = "State",
    y = "Average Incidence Rate per 100,000"
  ) +
  theme_minimal()

plot_cases <- ggplot(state_trends, aes(x = reorder(State, avg_cases), y = avg_cases)) +
  geom_col(fill = "darkred") +
  coord_flip() +
  labs(
    title = "Highest Disease Burden",
    subtitle = "Top 10 States by Avg Annual Cases",
    x = "", 
    # Hide the state label on the second plot to save space
    y = "Annual Case Count"
  ) +
  theme_minimal(base_size = 11)

# Display side-by-side
combined_plot <- plot_rates + plot_cases + 
  plot_annotation(
    title = "Comparing relative transmission risk against absolute case volume(1993-2023)",
    theme = theme(plot.title = element_text(face = "bold", size = 14))
  )

# Display the combined plot
combined_plot