#Pleasae analyse dataset movies available after installing package ggplot2movies
# 1. Please visualize main features of this dataset using ggplot2 package
# 2. Create chart with few panels characterising 3 most important fetaures of
# this dataset.


# Library packages
library(ggplot2movies)
library(ggplot2)
library(dplyr)
library(tidyr)
library(corrplot)

#Data summary
?movies
summary(movies)
df <- movies


# Data processing
# Create "category" column
df <- df %>%
  mutate(category = case_when(
    Action == 1 ~ "Action",
    Animation == 1 ~ "Animation",
    Comedy == 1 ~ "Comedy",
    Drama == 1 ~ "Drama",
    Documentary == 1 ~ "Documentary",
    Romance == 1 ~ "Romance",
    Short == 1 ~ "Short",
    TRUE ~ "Other" 
  ))

# Drop binary category columns
df <- df %>%
  select(-Action, -Animation, -Comedy, -Drama, -Documentary, -Romance, -Short)

# Edit data type of variables
df <- df %>%
  mutate(
    title = as.character(title),          
    year = as.integer(year),              
    budget = as.numeric(budget),          
    length = as.numeric(length),          
    rating = as.numeric(rating),              
    votes = as.integer(votes),            
    category = as.factor(category),       
    mpaa = as.factor(mpaa)                
  )

# Create “unknown” value for missing value in the "budget" column
df <- df %>%
  mutate(budget = ifelse(is.na(budget), "Unknown", budget))

# Create sub table for rate-votes each movie
rate_votes <- df %>%
  select(title, year, rating, votes)

# Create sub table about number of movies each category 
genre_summary <- df %>%
  select(title, year, rating, votes, category) %>%
  group_by(category) %>%
  summarise(
    count = n(),  # Số lượng phim
    avg_rate = mean(rating, na.rm = TRUE),  
    avg_votes = mean(votes, na.rm = TRUE)  
  )

# Create sub table about rates and number of movies each year
yearly_trends <- df %>%
  select(year, rating) %>%
  group_by(year) %>%
  summarise(
    avg_rate = mean(rating, na.rm = TRUE),
    movie_count = n()  
  )

# Create sub table about movies duration and movies rating
length_analysis <- df %>%
  select(title, length, rating) %>%
  mutate(
    length_category = case_when(
      length < 60 ~ "Short",
      length >= 60 & length <= 120 ~ "Medium",
      length > 120 ~ "Long"
    )
  ) %>%
  group_by(length_category) %>%
  summarise(
    avg_rate = mean(rating, na.rm = TRUE),  # Điểm trung bình
    movie_count = n()  # Số lượng phim
  )

# Create sub table for top movies in the dataset
top_movies <- df %>%
  select(title, year, rating, votes) %>%
  arrange(desc(rating), desc(votes)) %>%
  slice_head(n = 10)  

# Create sub table top_movies_filtered
top_movies_filtered <- df %>%
  select(title, year, rating, votes) %>%
  filter(!is.na(rating) & !is.na(votes) & votes >= 30) %>%
  arrange(desc(rating), desc(votes)) %>%
  slice_head(n = 20)  

# Data analysis and visualization
# Chart 1: Relationship between rating and votes
ggplot(rate_votes, aes(x = rating, y = votes)) +
  geom_point(alpha = 0.5, color = "darkorange") +
  theme_minimal() +
  labs(
    title = "Relationship between rating and votes",
    x = "Rating",
    y = "Votes"
  )

# Chart 2: Number of movies and average rating of each category
ggplot(genre_summary, aes(x = reorder(category, -count), y = count, fill = avg_rate)) +
  geom_bar(stat = "identity") +
  scale_fill_gradient(low = "blue", high = "darkorange") +
  theme_minimal() +
  labs(
    title = "Number of movies and average rating of each category",
    x = "Category",
    y = "Number of movies",
    fill = "Average ratings"
  )

# Chart 3: Number of movies over years
ggplot(yearly_trends, aes(x = year)) +
  geom_bar(aes(y = movie_count, fill = "Number of movies"), color="darkorange", stat = "identity", alpha = 0.5) +
  theme_minimal() +
  labs(
    title = "Number of movies over years",
    x = "Year",
    y = "Number of movies",
    color="darkorange",
    fill=""
  )

# Chart 4: Average rating by movies duration
ggplot(length_analysis, aes(x = length_category, y = avg_rate, fill = length_category)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  theme_minimal() +
  labs(
    title = "Average rating by movies duration",
    x = "Movies duration",
    y = "Average rating"
  )

# Chart 5: Top 20 movies with highest rating
ggplot(top_movies_filtered, aes(x = reorder(title, rating), y = rating)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  theme_minimal() +
  labs(
    title = "Top 20 movies with highest rating (votes >= 30)",
    x = "Title",
    y = "Rating"
  )

# Chart 6: Ratings Distribution
ggplot(df, aes(x = rating)) +
  geom_histogram(aes(y = after_stat(density)), bins = 30, fill = "skyblue", alpha = 0.7) +
  geom_density(color = "orange", linewidth = 1) +
  theme_minimal() +
  labs(
    title = "Rating distribution",
    x = "Rating",
    y = "Density"
  )

# Chart 7: Correlation between numeric variables
numeric_columns <- df %>%
  select(rating, votes, length) %>%
  na.omit()

correlation_matrix <- cor(numeric_columns)

corrplot(correlation_matrix, method = "color", addCoef.col = "black",
         tl.cex = 0.8, number.cex = 0.7, title = "Correlation between numeric variables",
         mar = c(0, 0, 1, 0))

# Chart 8: Relationship between votes and rates by category
ggplot(df, aes(x = votes, y = rating)) +
  geom_point(alpha = 0.5, color = "darkorange") +
  facet_wrap(~category) +
  theme_minimal() +
  labs(
    title = "Relationship between votes and rates by category",
    x = "Vote",
    y = "Rating"
  )

# Chart 9: Relationship between length and rates by category
ggplot(df, aes(x = length, y = rating)) +
  geom_point(alpha = 0.5, color = "darkblue") +
  facet_wrap(~category) +
  theme_minimal() +
  labs(
    title = "Relationship between duration and rates by category",
    x = "Duration",
    y = "Rating"
  )
