# ================================================
# WeatherWise - Smart Weather Analysis &
# Recommendation System
# File : main.R  (Main controller of the project)
# ================================================

# ---------- Step 1: Check that all files exist ----------
files_needed <- c(
  "modules/module1_analyzer.R",
  "modules/module2_recommend.R",
  "modules/module3_factorial.R",
  "modules/module4_converter.R",
  "modules/module5_area.R",
  "data/weather.csv"
)

all_files_ok <- TRUE
for (f in files_needed) {
  if (!file.exists(f)) {
    cat("[MISSING] ", f, "\n")
    all_files_ok <- FALSE
  }
}

if (!all_files_ok) {
  stop("Some project files are missing. Please check the folder structure.")
}

# ---------- Step 2: Load all modules ----------
source("modules/module1_analyzer.R")
source("modules/module2_recommend.R")
source("modules/module3_factorial.R")
source("modules/module4_converter.R")
source("modules/module5_area.R")

# ---------- Step 3: Function to display the main menu ----------
show_menu <- function() {
  cat("\n=====================================\n")
  cat("     WEATHERWISE - MAIN MENU\n")
  cat("=====================================\n")
  cat("1. Analyze Weather Data\n")
  cat("2. Get Weather Recommendation\n")
  cat("3. Calculate Factorial\n")
  cat("4. Convert Celsius to Fahrenheit\n")
  cat("5. Calculate Rectangle Area\n")
  cat("6. Exit\n")
  cat("=====================================\n")
}

# ---------- Step 4: Welcome message ----------
cat("=====================================\n")
cat("        WELCOME TO WEATHERWISE       \n")
cat("=====================================\n")

# ---------- Step 5: Main program loop ----------
repeat {
  show_menu()
  choice <- trimws(readline("Enter your choice (1-6): "))
  
  if (choice == "1") {
    analyze_weather_data()
  } else if (choice == "2") {
    weather_recommendation()
  } else if (choice == "3") {
    factorial_module()
  } else if (choice == "4") {
    converter_module()
  } else if (choice == "5") {
    area_module()
  } else if (choice == "6") {
    cat("\nThank you for using WeatherWise. Goodbye!\n")
    break
  } else {
    cat("\nInvalid choice! Please enter a number from 1 to 6.\n")
  }
  
  readline("\nPress Enter to return to the main menu...")
}