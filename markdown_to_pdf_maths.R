### R Markdown to PDF: mathematics syntax function

# Seemingly, the $ wrapper is not so great with PDF rendering
# \\( ... \\) is a more effective wrapper

convert_dollar_to_parentheses_in_rmd <- function(input_file, output_file) {
  # Read the content of the R Markdown file
  content <- readLines(input_file, warn = FALSE)
  
  # Function to convert $...$ to \( ... \)
  convert_dollar_to_parentheses <- function(text) {
    gsub("\\$(.*?)\\$", "\\\\(\\1\\\\)", text)
  }
  
  # Apply the conversion to each line of the file
  converted_content <- sapply(content, convert_dollar_to_parentheses)
  
  # Write the converted content to a new file
  writeLines(converted_content, output_file)
}

# Example usage
input_file <- "C91ED_regression_interactions.Rmd"
output_file <- "C91ED_regression_interactions_converted.Rmd"
convert_dollar_to_parentheses_in_rmd(input_file, output_file)
