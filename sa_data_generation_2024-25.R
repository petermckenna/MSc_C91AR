# Summative Assessment data generation

# About simstudy ----
# Simulation using simstudy has two fundamental steps. The user... 
  # (1) defines the data elements of a data set and 
  # (2) generates the data based on these definitions.
# You build the dataset by incrementally assigning each variable based on its relationship to existing variables

# Setup ----
pacman::p_load(simstudy,
               GGally,
               tidyverse,
               messy)

# Online examples ----

# set parameters for 'age' dist
def <- 
  defData(varname = "age", 
          dist = "normal", 
          formula = 10,
          variance = 2)

# Set parameters for 'female' dist
def <- 
  defData(def, 
          varname = "female", 
          dist = "binary",
          formula = "-2 + age * 0.1", 
          link = "logit")

# set parameters for 'visits' dist
def <- 
  defData(def, 
          varname = "visits", 
          dist = "poisson",
          formula = "1.5 - 0.2 * age + 0.5 * female", 
          link = "log")

# Parameters defined ----
  
  # `varname` provides the name of the variable to be generated. 
  
  # `formula` is either a value or string representing any valid R formula 
  # (which can include function calls) that in most cases defines the mean of the distribution. 
  
  # `variance` is a value or string that specifies either the variance or 
  # other parameter that characterizes the distribution; the default is 0. 
  
  # `dist` is defines the distribution of the variable to be generated; the default is normal. 
  
  # `link` is a function that defines the relationship of the formula with the mean value, 
  # and can either identity, log, or logit, depending on the distribution; the default is identity.

# Generating the data ----
dd <- 
  genData(1000, def)
dd


# My attempt

def <- 
  defData(varname="x", 
          formula = 10, 
          variance = 2, 
          dist = "normal")

def <- 
  defData(def, 
          varname="y", 
          formula = "3 + 0.5 * x", 
          variance = 1, 
          dist = "normal")

dd <- 
  genData(250, def)

dd <- 
  trtAssign(dd, 
            nTrt = 4, 
            grpName = "grp", 
            balanced = TRUE)

dd

# Examine the data
ggpairs(dd)


# Correlated data with transformation ----
  
  # using genCorData from simstudy
  # https://kgoldfeld.github.io/simstudy/reference/genCorData.html

# Correlation structure of the variance-covariance matrix defined by 
# sigma and rho. Options include 
  # "ind" for an independence structure
  # "cs" for a compound symmetry structure
  # "ar1" for an autoregressive structure.

mu <- 
  c(3, 8, 15) # a vector of means

sigma <- 
  c(1, 2, 3) # a vector of standard deviations

corMat <- 
  matrix(c(1, .2, .8, 
           .2, 1, .6, 
           .8, .6, 1), 
         nrow = 3) # correlation matrix

dtcor1 <- 
  genCorData(1000, 
             mu = mu, 
             sigma = sigma, 
             rho = .7,  # supply if corMat not provided
             corstr = "cs")

dtcor2 <- 
  genCorData(1000, 
             mu = mu, 
             sigma = sigma, 
             corMatrix = corMat)

dtcor3 <-
  genCorData(1000, 
             mu = mu, 
             sigma = sigma, 
             rho = .5,  # supply if corMat not provided
             corstr = "ind")
  

dtcor1
dtcor2

round(var(dtcor1[, .(V1, V2, V3)]), 3)
round(cor(dtcor1[, .(V1, V2, V3)]), 2)

round(var(dtcor2[, .(V1, V2, V3)]), 3)
round(cor(dtcor2[, .(V1, V2, V3)]), 2)


# Visualise correlations
ggpairs(dtcor1)
ggpairs(dtcor2)
ggpairs(dtcor3)


# Adapted for C91AR ----

# for reproducibility
set.seed(1965)

# Set data parameters
mu <- 
  c(5.4, 26, 1556) # a vector of means

sigma <- 
  c(1.2, 3.4, 935) # a vector of standard deviations

# specify correlation matrix
corMat2 <- 
  matrix(c(1, .34, -.08, 
           .34, 1, -.63, 
           -.08, -.63, 1), 
         nrow = 3) # has to be symmetric

dtcor4 <-
  genCorData(250, 
             mu = mu, 
             sigma = sigma, 
             corMatrix = corMat2)

# Examine data
# ggpairs(dtcor4)

# Modify the data for assessment purposes ----

# convert to tibble
df <-
  dtcor4 |>
  tibble() 

# rename varaibles
df <-
  df |>
  rename(robot_likeability = V1,   # robot_likeability
         robot_trust = V2,       # robot_trust  
         trust_response_time = V3) # trust_response_time

# Convert robot_likeability into an integer
df$robot_likeability <-
  as.integer(df$robot_likeability)

# round double data to 2 decimals
df <-
  df |>
  mutate_if(is.numeric, 
            round, 
            digits = 2)

# Mess up the data
  # student will need to ill in the blanks wih the mean
df_messy <-
  df |>
  make_missing(cols = "robot_likeability",
               missing = NA,
               messiness = 0.02) |>
  make_missing(cols = "trust_response_time",
               missing = NA,
               messiness = 0.04)

# Add unformatted date column ----
  # Generate a sequence of dates
start_date <- 
  as.Date("2021-01-01")

end_date <- 
  as.Date("2022-08-07")

date_seq <- 
  seq.Date(start_date, 
           end_date, 
           length.out = 250)

# Format the dates
formatted_dates <- 
  format(date_seq, "%m-%d-%Y")

# Display the first few dates to check
head(formatted_dates)

# Mutate to df_messy
df_messy <-
  df_messy |>
  mutate(dates = formatted_dates)

# Add sex vector ----
  # Generate a vector of 250 observations with "Male" and "Female"
sex_vector <- 
  sample(c("Male", "Female"), 
         size = 250, 
         replace = TRUE)

# Add erroneous sex values ----
# Change the value of the 10th row to "Female"
sex_vector[10] <- "female"
sex_vector[57] <- "ffemale"
sex_vector[191] <- "male"
sex_vector[243] <- "female"
sex_vector[113] <- "Malep"
sex_vector[98] <- "male"

# Display the first few observations to check
head(sex_vector)
unique(sex_vector)

# Mutate to df_messy
df_messy <-
  df_messy |>
  mutate(sex = sex_vector,
         .after = 1)

# examine sex
unique(df_messy$sex)

# Mess up vector names ----
names(df_messy)

df_messy_final <-
  df_messy |>
  rename(I.d = id,
         SEX = sex,
         Robot.Likeability = robot_likeability,
         robot.trust. = robot_trust,
         Exp.Date = dates)

# Examine the data
ggpairs(df_messy_final, 
        columns = 3:5)

# Write data
write_csv(df_messy_final, 
          "data_raw/SA_Data_24_25.csv")

  
# # untidy our maze data
  # df_messy <-
  # df |>
  # make_missing(cols = "follow_robot", 
  #              missing = NA,
  #              messiness = 0.05) |> # add missing values to follow_robot
  # make_missing(cols = "rt",
  #              missing = NA,
  #              messiness = 0.3) |> # add missing and erroneous values to rt
  # add_special_chars(cols = "condition") # add special chars to condition levels  




# Resources
# https://kgoldfeld.github.io/simstudy/
# https://kgoldfeld.github.io/simstudy/articles/simstudy.html