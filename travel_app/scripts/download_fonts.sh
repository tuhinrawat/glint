#!/bin/bash

# Create fonts directory if it doesn't exist
mkdir -p assets/fonts

# Download Poppins font files
curl -o assets/fonts/Poppins-Regular.ttf https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Regular.ttf
curl -o assets/fonts/Poppins-Medium.ttf https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Medium.ttf
curl -o assets/fonts/Poppins-SemiBold.ttf https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-SemiBold.ttf
curl -o assets/fonts/Poppins-Bold.ttf https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Bold.ttf

echo "Poppins fonts downloaded successfully!" 