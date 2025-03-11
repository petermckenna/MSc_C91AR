# Computer lab 7: Data Creation

# Galton's data on the heights of parents and their children, by child
# URL: https://friendly.github.io/HistData/reference/GaltonFamilies.html

# Load packages
pacman::p_load(HistData,
               tidyverse,
               GGally)

# dataset creation for correlation computer lab
df <- 
  GaltonFamilies


# Wrangle the necessary data
  # examine correlation between father's and sons
df1 <-
  df |>
  filter(gender == "male") |>
  select(father,
         son = childHeight)

# check the data
ggpairs(df1)


  # examine correlation between mother's and daughters
df2 <-
  df |>
  filter(gender == "female") |>
  select(mother,
         daughter = childHeight)

# check the data
ggpairs(df2)

# Write the data
write_csv(df1, "data_tidy/father_son_height.csv")

# Write the data
write_csv(df2, "data_tidy/mother_daughter_height.csv")
