# Script to create messy data for Computer lab 6

# load packages
pacman::p_load(tidyverse,
               messy)



# read in the data
handw <-
read_csv("data_tidy/heights_and_weights.csv",
col_types = "dd")

# metadata
# vec1 = height_in
# vec2 = weight_lbs


# mess up the data
handw_messy <-
handw |>
make_missing(cols = "height_in",
missing = NA,
messiness = 0.02) |>
make_missing(cols = "weight_lbs",
missing = NA,
messiness = 0.01)

## example code
#df_messy <-
#  df |>
#  make_missing(cols = "follow_robot", 
#               missing = NA,
#               messiness = 0.05) |> # add missing values to follow_robot
#  make_missing(cols = "rt",
#               missing = NA,
#               messiness = 0.3) |> # add missing and erroneous values to rt
#  add_special_chars(cols = "condition") # add special chars to condition levels
  


# untidy vector labels
    # x = height_in, y = weight_lbs

handw_messy <-
handw_messy |>
rename(HeiGhT_inches = height_in,
W3ighT_lBz = weight_lbs)


# Now, you have messed up the data in terms of the vector labels and missing values


# Write csv to data_raw folder
write_csv(handw_messy, "data_raw/handw_messy.csv")




