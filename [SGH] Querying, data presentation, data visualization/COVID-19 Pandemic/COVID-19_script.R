# __I.Read data__
df <- read.csv("/Users/mac/Documents/[SGH] Materials/[SGH] Data Viz/Final Project/Covid Data.csv", header=TRUE, sep=",")
summary(df)


# __II.Data processing__
# Covert columns name to lower
colnames(df) <- tolower(colnames(df))

# Convert data type of variables
columns_to_convert <- c("usmer", "medical_unit", "sex", "patient_type", "intubed", 
                        "pneumonia", "pregnant", "diabetes", "copd", "asthma", 
                        "inmsupr", "hipertension", "other_disease", "cardiovascular", 
                        "obesity", "renal_chronic", "tobacco", "clasiffication_final", "icu")

df[columns_to_convert] <- lapply(df[columns_to_convert], as.factor)

# Convert boolean variable
boolean_columns <- c("pneumonia", "pregnant", "diabetes", "copd", "asthma",
                     "inmsupr", "hipertension", "cardiovascular", "renal_chronic",
                     "other_disease", "obesity", "tobacco", "intubed", "icu")

df[boolean_columns] <- lapply(df[boolean_columns], function(x) {
  ifelse(x == 1, "Yes", ifelse(x == 2, "No", NA))
})

# Convert gender column
df$sex <- ifelse(df$sex == 1, "woman", "man")

# Convert patient type column
df$patient_type <- ifelse(df$patient_type == 1, "returned home", "hospitalization")

# Convert classification final column
df$clasiffication_final <- ifelse(df$clasiffication_final %in% c(1, 2, 3), "Positive", "Negative")

# Impute data
df[df == 97 | df == 99] <- NA

variable_to_impute <- c("diabetes", "copd", "asthma", "inmsupr", "hipertension",
                        "other_disease", "cardiovascular", "obesity", "renal_chronic",
                        "tobacco", "pneumonia")

mode_impute <- function(x) {
  ux <- unique(x[!is.na(x)])  
  ux[which.max(tabulate(match(x, ux)))]  
}

for (x in variable_to_impute) {
  df[[x]][is.na(df[[x]])] <- mode_impute(df[[x]])
}

df$age[is.na(df$age)] <- median(df$age, na.rm = TRUE)

df$pregnant[is.na(df$pregnant)] <- "No"

# Check number of missing data
sapply(df, function(x) sum(is.na(x)))

# Create survive column from date_died column
df$survive <- ifelse(is.na(df$date_died) | df$date_died == "9999-99-99", "Yes", "No")

# Create comorbidities column 
disease_columns <- c("pneumonia", "pregnant", "diabetes", "copd", "asthma", 
                     "inmsupr", "hipertension", "other_disease", "cardiovascular", 
                     "obesity", "renal_chronic", "tobacco")

df$comorbidities <- apply(df[disease_columns], 1, function(row) {
  diseases <- names(row)[row == "Yes"]
  if (length(diseases) > 0) {
    paste(diseases, collapse = ", ")
  } else {
    "No"
  }
})

# Create number of comorbidities column
df$num_comorbidities <- rowSums(df[, c("diabetes", "copd", "asthma", "inmsupr", 
                                       "hipertension", "cardiovascular", "obesity", 
                                       "renal_chronic", "tobacco")] == "Yes", na.rm = TRUE)

# Create high risk column
df$high_risk <- ifelse(df$age > 60 | df$num_comorbidities >= 2, "Yes", "No")

# Filter dataset with positive covid 19 patient
df <- df[df$clasiffication_final == "Positive", ]

# Drop columns
df <- df[, !(names(df) %in% c("date_died", "icu", "intubed", "usmer", "medical_unit"))]

#__III. Data Analysis__
library(ggplot2)
library(scales)

# Death Rate
ggplot(df, aes(x = survive, fill = survive)) +
  geom_bar() +
  labs(title = "Survival Distribution", x = "Survive", y = "Number of case") +
  scale_y_continuous(labels = comma) +
  theme_minimal()

# Death Rate (pie chart)
survive_data <- df %>%
  group_by(survive) %>%
  summarise(Count = n()) %>%
  mutate(Percentage = Count / sum(Count) * 100)

ggplot(survive_data, aes(x = "", y = Percentage, fill = survive)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  labs(title = "Survival Distribution", fill = "Survive") +
  theme_void()

# Death Rate by Age group
ggplot(df, aes(x = age, fill = survive)) +
  geom_histogram(binwidth = 5, position = "stack", color = "black") +
  labs(title = "Death rate by age group", x = "Age", y = "Number of case") +
  scale_y_continuous(labels = comma) +
  theme_minimal()

# Death rate by gender
ggplot(df, aes(x = sex, fill = survive)) +
  geom_bar() +
  labs(title = "Death Rate by Gender", x = "Gender", y = "Number of case") +
  scale_y_continuous(labels = comma) +
  theme_minimal()

# Boxplot number of comorbidities by gender
ggplot(df, aes(x = sex, y = num_comorbidities, fill = sex)) +
  geom_boxplot(outlier.color = "red", outlier.shape = 1, alpha = 0.7) +
  labs(title = "Distribution of Comorbidities by Gender", 
       x = "Gender", 
       y = "Number of Comorbidities") +
  theme_minimal()

# High risk by gender
ggplot(df, aes(x = sex, fill = high_risk)) +
  geom_bar() +
  labs(title = "High Risk Patients by Gender", 
       x = "Gender", 
       y = "Number of case") +
  theme_minimal() +
  scale_y_continuous(labels = comma)

# Death rate by age group and gender
ggplot(df, aes(x = age, fill = survive)) +
  geom_histogram(binwidth = 5, position = "stack", color = "black") +
  facet_wrap(~ sex) +
  labs(title = "Survival vs Age by Gender", 
       x = "Age", 
       y = "Number of case") +
  theme_minimal() +
  scale_y_continuous(labels = comma)

# Bubble Chart
ggplot(df, aes(x = age, y = num_comorbidities, size = num_comorbidities, color = survive)) +
  geom_point(alpha = 0.6) +
  scale_size(range = c(1, 10)) +
  labs(title = "Bubble Chart of Age vs Comorbidities", 
       x = "Age", 
       y = "Number of Comorbidities", 
       color = "Survival Status") +
  theme_minimal()

# Death rate by comorbidities
comorbidities <- c("diabetes", "copd", "asthma", "inmsupr", "hipertension", 
                   "cardiovascular", "obesity", "renal_chronic", "tobacco")


comorbidity_mortality <- data.frame(
  Comorbidity = comorbidities,
  Mortality_Rate = sapply(df[comorbidities], function(x) {
    sum(df$survive == "No" & x == "Yes", na.rm = TRUE) / sum(x == "Yes", na.rm = TRUE)
  })
)

ggplot(comorbidity_mortality, aes(x = reorder(Comorbidity, -Mortality_Rate), y = Mortality_Rate, fill = Comorbidity)) +
  geom_bar(stat = "identity") +
  labs(title = "Mortality Rate by Comorbidities", x = "Comorbidity", y = "Mortality Rate") +
  scale_y_continuous(labels = percent) +
  theme_minimal() +
  coord_flip()

# Violin Plot of number of comorbidities
ggplot(df, aes(x = factor(patient_type, labels = c("Home", "Hospital")), y = num_comorbidities, fill = factor(patient_type, labels = c("Home", "Hospital")))) +
  geom_violin(alpha = 0.7) +
  labs(title = "Distribution of Comorbidities by Treatment Type", 
       x = "Treatment Type", 
       y = "Number of Comorbidities") +
  theme_minimal()

# Boxplot of number of comorbidities and death rate
ggplot(df, aes(x = survive, y = num_comorbidities, fill = survive)) +
  geom_boxplot() +
  labs(title = "Number of Comorbidities vs Survival", x = "Survive", y = "Number of Comorbidities") +
  theme_minimal()

# Death rate by patient type 
ggplot(df, aes(x = patient_type, fill = survive)) +
  geom_bar() +
  labs(title = "Survival Rate by Patient Type", x = "Patient Type (1: Home, 2: Hospitalized)", y = "Number of case") +
  scale_y_continuous(labels = comma) +
  theme_minimal()

# High risk by patient type
ggplot(df, aes(x = factor(patient_type, labels = c("Home", "Hospital")), fill = high_risk)) +
  geom_bar() +
  labs(title = "High Risk Patients by Treatment Type", 
       x = "Treatment Type", 
       y = "Proportion of High Risk Patients") +
  theme_minimal() +
  scale_y_continuous(labels = comma)

# Number of comorbidities by patient type
ggplot(df, aes(x = factor(patient_type, labels = c("Home", "Hospital")), y = num_comorbidities, fill = factor(patient_type, labels = c("Home", "Hospital")))) +
  geom_boxplot(outlier.color = "red", outlier.shape = 1, alpha = 0.7) +
  labs(title = "Number of Comorbidities by Treatment Type", 
       x = "Treatment Type", 
       y = "Number of Comorbidities") +
  theme_minimal()


# Death rate by high risk
ggplot(df, aes(x = high_risk, fill = survive)) +
  geom_bar() +
  labs(title = "High Risk vs Survival", x = "High Risk", y = "Number of case") +
  scale_y_continuous(labels = comma) +
  theme_minimal()

# Death rate by pregnancy
ggplot(df[df$pregnant == "Yes", ], aes(x = survive, fill = survive)) +
  geom_bar() +
  labs(title = "Survival Rate for Pregnant Patients", x = "Survive", y = "Count") +
  scale_y_continuous(labels = comma) +
  theme_minimal()



