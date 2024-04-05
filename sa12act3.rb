require "httparty"


# results = HTTParty.get(url, format: :json, :headers => { 'X-AIO-Key': '#{api_key}' })

def get_weather_data(location, date)
  results = {}
  api_key = "14e79b7a71e27b2505689453f88fd3d7"
  location_api = "http://api.openweathermap.org/geo/1.0/direct?q=#{location}&limit=1&appid=#{api_key}"
  location_results = HTTParty.get(location_api, format: :json)

  lat = location_results[0]["lat"]
  lon = location_results[0]["lon"]

  weather_api = "https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&appid=#{api_key}"
  results["wather_data"] = HTTParty.get(weather_api, format: :json)

  api_key_history = "b4167869d17747d0a1930304240504"
  history_api = "https://api.weatherapi.com/v1/history.json?q=#{location}&dt=#{date}&key=#{api_key_history}"
  results["history_data"] = HTTParty.get(history_api, format: :json)

  # puts results["history_data"]["forecast"]["forecastday"][0]["hour"].inject(0){|sum,e| sum + e["temp_f"]}

  return results
end

def task_1
  location = "london"
  date = "2024-04-01"
  results = get_weather_data(location, date)

  puts "temperature: #{results["wather_data"]["main"]["temp"]}"
  puts "humidity: #{results["wather_data"]["main"]["humidity"]}"
  puts "weather condition: #{results["wather_data"]["weather"][0]["main"]}"

  total_temp = results["history_data"]["forecast"]["forecastday"][0]["hour"].inject(0){|sum,e| sum + e["temp_f"]}
  average = (total_temp/24).round(2)
  puts "average temperature of #{date} is #{average}"

end

def get_exchange_rate_data(source, destination)
  exchange_rate = 0
  api_key = "a1388899cacecefdad9bcfb3"
  weather_api = "https://v6.exchangerate-api.com/v6/#{api_key}/latest/#{source}"
  results = HTTParty.get(weather_api, format: :json)
  exchange_rate = results["conversion_rates"][destination]

  return exchange_rate
end

def convert_currency(source, destination, amount)
  exchange_rate = get_exchange_rate_data(source, destination)
  result = exchange_rate.to_f * amount.to_f
  return result
end

def task_2
  source = "USD"
  destination = "BDT"
  amount = 12
  result = convert_currency(source, destination, amount).round(2)

  puts "#{amount} #{source} to #{destination} is #{result} "


end


task_1
puts
task_2
puts
task_3
