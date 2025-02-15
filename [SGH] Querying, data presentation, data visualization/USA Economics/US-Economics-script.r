# 1. Please analyse using visual technics #economics dataset available in package # ggplot2.
# 2. Visualize charasteristics of this dataset.
# 3. Create bublechart for 3 variables of this dataset.

# library packages
library(ggplot2)
library(dplyr)

# Data overview
?economics
df <- economics
show(df)
summary(df)

# Data Processing
# Create column "year" using column "date"
df <- df %>% 
  mutate(Year = format(as.Date(date, "%Y-%m"), "%Y"))

# Calculate average value of variables group by year
df_yearly <- df %>%
  group_by(Year) %>%
  summarise(
    avg_pce = mean(pce, na.rm = TRUE),
    avg_pop = mean(pop, na.rm = TRUE),
    avg_psavert = mean(psavert, na.rm = TRUE),
    avg_uempmed = mean(uempmed, na.rm = TRUE),
    avg_unemploy = mean(unemploy, na.rm = TRUE)
  )

# Create "pce_per_capita" column
df <- df %>% 
  mutate(pce_per_capita = pce / (pop * 1000))

# Create “unemployment_rate” column
df <- df %>% 
  mutate(unemployment_rate = unemploy / pop * 100)

# Create correlation matrix between variables
correlation_matrix <- cor(df %>% select(pce, pop, psavert, uempmed, unemploy), use = "complete.obs")

# Data analysis
# Distribution of variables
# psavert
ggplot(df, aes(x = psavert, fill = "Savings Rate")) +
  geom_density(alpha = 0.5, color = "darkgreen") +
  labs(title = "Distribution of Personal Savings Rate", x = "Savings Rate (%)", y = "Density") +
  theme_minimal()

# pce
ggplot(df, aes(x = pce, fill = "Personal Consumption Expenditures")) +
  geom_density(alpha = 0.5, color = "darkgreen") +
  labs(title = "Distribution of Personal Consumption Expenditures", x = "Consumption Expenditures", y = "Density") +
  theme_minimal()


# Trends of average of variables over time
# psavert
ggplot(df_yearly, aes(x = as.numeric(Year))) +
  geom_line(aes(y = avg_psavert, color = "Savings Rate"), size = 1) +
  theme_minimal()

# pce
ggplot(df_yearly, aes(x = as.numeric(Year))) +
  geom_line(aes(y = avg_pce, color = "Personal Consumption Expenditures"), size = 1) +
  theme_minimal()

# pop
ggplot(df_yearly, aes(x = as.numeric(Year))) +
  geom_line(aes(y = avg_pop, color = "Average Population"), size = 1) +
  theme_minimal()

# uempmed
ggplot(df_yearly, aes(x = as.numeric(Year))) +
  geom_line(aes(y = avg_uempmed, color = "Duration of Unemployment"), size = 1) +
  theme_minimal()

# unemploy
ggplot(df_yearly, aes(x = as.numeric(Year))) +
  geom_line(aes(y = avg_unemploy, color = "Unemployment"), size = 1) +
  theme_minimal()

# pce_per_capita
ggplot(df, aes(x = date)) +
  geom_line(aes(y = pce_per_capita, color = "Personal expenditure per capita"), size = 1) +
  theme_minimal()

# unemployment_rate
ggplot(df, aes(x = date)) +
  geom_line(aes(y = unemployment_rate, color = "Unemployment rate"), size = 1) +
  theme_minimal()

# The relationship between variables
# Corrlation matrix
correlation_matrix <- data.frame(
  Var1 = rep(rownames(correlation_matrix), each = ncol(correlation_matrix)),
  Var2 = rep(colnames(correlation_matrix), times = nrow(correlation_matrix)),
  value = as.vector(correlation_matrix)
)
ggplot(correlation_matrix, aes(Var1, Var2, fill = value)) +
  geom_tile(color = "white") +  
  geom_text(aes(label = round(value, 2)), color = "black", size = 4) +  
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab", 
                       name = "Correlation") +  
  theme_minimal() +  
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +  
  labs(x = "", y = "", title = "Correlation Matrix")

# Unemploy vs PCE
ggplot(data = df, aes(x = unemploy, y = pce)) +
  geom_point(color = "blue", size = 2, alpha = 0.7) + 
  labs(
    title = "Relationship between Unemployment and Personal Consumption Expenditures",
    x = "Number of Unemployed (thousands)",
    y = "Personal Consumption Expenditures (billions of dollars)"
  ) +
  theme_minimal() + 
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10)
  )

# Duration of unemployment vs PCE
ggplot(data = df, aes(x = uempmed, y = pce)) +
  geom_point(color = "blue", size = 2, alpha = 0.7) + 
  labs(
    title = "Relationship between Duraiton of Unemployment and Personal Consumption Expenditures",
    x = "Duration (week)",
    y = "Personal Consumption Expenditures (billions of dollars)"
  ) +
  theme_minimal() + 
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10)
  )

# Pce ~ unemploy ~ pop (bubble chart)
ggplot(df, aes(x = unemploy, y = pce, color = pop)) +
  geom_point(alpha = 0.7) +
  scale_size_continuous(range = c(2, 10)) +
  labs(title = "Bubble Chart: PCE vs Unemployment",
       x = "Unemployment (Thousands)",
       y = "PCE (Billions of Dollars)",
       color = "Population (Thousands)",
       ) +
  theme_minimal()


