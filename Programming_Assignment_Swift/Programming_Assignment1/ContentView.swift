//
//  ContentView.swift
//  Programming_Assignment1
//
//  Created by Finn Goldmann on 08/10/2026.
//

import SwiftUI
import SwiftData
import CoreLocation

struct WeatherData: Decodable{
    let latitude: Double
    let longitude: Double
    let hourly: hourly
}

struct hourly: Decodable{
    let time: [String]
    let temperature_2m: [Double]
    let precipitation_probability: [Double]
    let cloud_cover: [Double]
}

struct ContentView: View {
    @State private var API = "https://api.open-meteo.com/v1/forecast?latitude=53.5507&longitude=9.993&hourly=temperature_2m,precipitation_probability,cloud_cover"
    @State private var fetchedData: WeatherData?
    @State private var errorMessage: String?
    @State private var city: String?
    

    var body: some View {
        NavigationView{
            ZStack{
                Image("cloudy")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    LinearGradient(
                        colors: [.white, .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 350)
                    .ignoresSafeArea()
                    
                    Spacer()
                }
                
                VStack{
                    Text("Grab a jacket, it might rain today")
                        .font(.custom("InstrumentSerif-Regular", size: 50))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(width: 390)
                    Spacer()
                    
                    //Paste in the output of the API
                    if let fetchedData {
                        VStack{
                            VStack(alignment: .leading, spacing: 10){
                                HStack{
                                    Text("\(city ?? "failure")")
                                    
                                    Spacer()
                                    
                                    let currentTemparature = fetchedData.hourly.temperature_2m.first
                                    Text("\(currentTemparature ?? 0, specifier: "%.0f") °C")
                                }
                                .font(.custom("InstrumentSerif-Regular", size: 40))
                                .foregroundColor(.black)
                                
                                Divider()
                                
                                ScrollView(.horizontal, showsIndicators: false){
                                    HStack(spacing: 20){
                                        VStack(alignment: .leading){
                                            Text("Now")
                                                .fontWeight(.bold)
                                            Text("\(fetchedData.hourly.temperature_2m[0], specifier: "%.1f") °C")
                                        }
                                        Divider()
                                            .frame(height: 10)
                                        VStack(alignment: .leading){
                                            Text(forecastHour(offset: 1))
                                                .fontWeight(.bold)
                                            Text("\(fetchedData.hourly.temperature_2m[1], specifier: "%.1f") °C")
                                        }
                                        Divider()
                                            .frame(height: 10)
                                        VStack(alignment: .leading){
                                            Text(forecastHour(offset: 2))
                                                .fontWeight(.bold)
                                            Text("\(fetchedData.hourly.temperature_2m[1], specifier: "%.1f") °C")
                                        }
                                        Divider()
                                            .frame(height: 10)
                                        VStack(alignment: .leading){
                                            Text(forecastHour(offset: 3))
                                                .fontWeight(.bold)
                                            Text("\(fetchedData.hourly.temperature_2m[1], specifier: "%.1f") °C")
                                        }
                                        Divider()
                                            .frame(height: 10)
                                        VStack(alignment: .leading){
                                            Text(forecastHour(offset: 4))
                                                .fontWeight(.bold)
                                            Text("\(fetchedData.hourly.temperature_2m[1], specifier: "%.1f") °C")
                                        }
                                        Divider()
                                            .frame(height: 10)
                                        VStack(alignment: .leading){
                                            Text(forecastHour(offset: 5))
                                                .fontWeight(.bold)
                                            Text("\(fetchedData.hourly.temperature_2m[1], specifier: "%.1f") °C")
                                        }
                                        Divider()
                                            .frame(height: 10)
                                        VStack(alignment: .leading){
                                            Text(forecastHour(offset: 6))
                                                .fontWeight(.bold)
                                            Text("\(fetchedData.hourly.temperature_2m[1], specifier: "%.1f") °C")
                                        }
                                    }
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                                    .padding(15)
                                }.padding(.horizontal, -15)
                                
                                Divider()
                                
                                let averageProbability = fetchedData.hourly.precipitation_probability.reduce(0, +) / Double(fetchedData.hourly.precipitation_probability.count)
                                
                                Text("**\(averageProbability, specifier: "%.0f")%** chance of rain in average")
                                    .font(.system(size: 15))
                                    .foregroundColor(.black)
                                
                                Divider()
                                
                                let CloudCover = fetchedData.hourly.cloud_cover.reduce(0, +) / Double(fetchedData.hourly.cloud_cover.count)
                                
                                Text("**\(CloudCover, specifier: "%.0f")%** chance of cloud cover in average")
                                    .font(.system(size: 15))
                                    .foregroundColor(.black)
                            }
                            .frame(width: 350)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundColor(.white.opacity(0.85))
                            )
                        }
                        //.font(.system)
                    } else {
                      ProgressView()
                            .frame(width: 350)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundColor(.white)
                            )
                    }
                }
                
            }
        }
        .task{
            print("fetching data started")
           await fetchWeatherData()
        }
    }
    
    //function that fetches the data to the referring API
    func fetchWeatherData() async{
        // the guard let is a mandatory variable that has to contain a URL value from the API, otherwise it'll return an error in errorMessage
        guard let url = URL(string: API) else { errorMessage = "Invalid URL"; return }
        
        //If there's data that can be fetched do the following:
        do {
            // define data and response with the awaitening data from the URL
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // again it is mandatory that response gets a value before continuing
            // in this case it has to contain a positive statusCode from the HTTPURLResponse within 200 to 299 - common range for a success inquiry.
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                
                //if there's a bad response like 404 or 500 throw an error
                throw URLError(.badServerResponse)
            }
            
            //put the decoded data into the declared and empty fetchedData struct variable
            fetchedData = try JSONDecoder().decode(WeatherData.self, from: data)
            city = await geocode(latitude: fetchedData?.latitude ?? 0.0, longitude: fetchedData?.longitude ?? 0.0)
                
        } catch {
            //if the function isn't capable to execute the task (do) localize the error and declare it int errorMessage
            errorMessage = error.localizedDescription
        }
    }
    
    //We need a function that converts coordinates in the the city name
    func geocode(latitude: Double, longitude: Double) async -> String {
        //We declare the location through merging latitude and longitude to one variable
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        do {
            let placemarks = try await CLGeocoder().reverseGeocodeLocation(location)
            
            city = placemarks.first?.locality ?? "Unknown"
            
            return placemarks.first?.locality ?? "Unknown"
        } catch {
            return "Unknown City"
            print("geocoding failed cause: \(error.localizedDescription)")
        }
    }
    
    func forecastHour(offset: Int) -> String {
        let timeZone = TimeZone(identifier: "Europe/Dublin")!

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone

        let date = calendar.date(
            byAdding: .hour,
            value: offset,
            to: Date()
        )!

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = timeZone
        formatter.dateFormat = "ha"

        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
