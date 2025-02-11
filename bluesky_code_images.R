# Install the package if you haven't already
install.packages("reprex")

# Use reprex to create a shareable image
reprex::reprex({
  # Your R code here
  df1 |>
    group_by(condition, follow_robot) |>
    summarise(n = n(), .groups = 'drop') |>
    mutate(freq = n / total_n) |>
    mutate(freq = round(freq * 100, digits = 2))
})
