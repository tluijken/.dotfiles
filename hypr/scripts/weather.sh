#!/bin/bash

 declare -A WEATHER_ICON=(
    "01d": " ",
    "01n": " ",
    "02d": "  ",
    "02n": "  ",
    "03d": "  ",
    "03n": "  ",
    "04d": "  ",
    "04n": "  ",
    "09d": "  ",
    "09n": "  ",
    "10d": "  ",
    "10n": "  ",
    "11d": "  ",
    "11n": "  ",
    "13d": "  ",
    "13n": "  ",
    "50d": "  ",
    "50n": "  ",
) 

# API details
apiKey="d6db4f45df2f9d4dd44d511595aa89fd"
lat="52.29900825"
lon="6.50798832318185"

# Fetch weather data
response=$(curl -s "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric")

# Check if the request was successful
if [ $? -eq 0 ]; then
    icon=$(echo "$response" | jq -r '.weather[0].icon')
    temp=$(echo "$response" | jq -r '.main.temp' | awk '{printf "%d", $1}')
    description=$(echo "$response" | jq -r '.weather[0].description')
    feels_like=$(echo "$response" | jq -r '.main.feels_like' | awk '{printf "%d", $1}')

    # Prepare output JSON
    text="${WEATHER_ICON[$icon]}  $temp°"
    tooltip="<b> ${WEATHER_ICON[$icon]} $description </b>\nFeels like $feels_like° Rijssen"

    echo "{\"text\":\"$text\", \"tooltip\":\"$tooltip\"}"
else
    echo "{\"text\":\" 😭 \", \"tooltip\":\" 😭 \"}"
fi
