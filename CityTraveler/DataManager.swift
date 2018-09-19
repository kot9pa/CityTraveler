//
//  DataManager.swift
//  CityTraveler
//
//  Created by Konstantin on 15.11.2017.
//  Copyright © 2017 Konstantin. All rights reserved.
//

import Foundation

struct Location: Codable {
    let citiesFrom: [Country]
    let citiesTo: [Country]
    
    init(citiesFrom: [Country], citiesTo: [Country]) {
        self.citiesFrom = citiesFrom
        self.citiesTo = citiesTo
    }
    /*
     private enum CodingKeys : CodingKey {
     case citiesFrom, citiesTo
     }*/
}

struct Country: Codable {
    let countryTitle: String
    let cityTitle: String
    let stations: [Station]
    
    init(countryTitle: String, cityTitle: String, stations: [Station]) {
        self.countryTitle = countryTitle
        self.cityTitle = cityTitle
        self.stations = stations
    }
    /*
     private enum CodingKeys : CodingKey {
     case countryTitle, cityTitle, stations
     }*/
}

struct Station: Codable {
    let countryTitle: String
    let cityTitle: String
    let stationTitle: String
    
    init(countryTitle: String, cityTitle: String, stationTitle: String) {
        self.countryTitle = countryTitle
        self.cityTitle = cityTitle
        self.stationTitle = stationTitle
    }
    /*
     private enum CodingKeys : CodingKey {
     case countryTitle, cityTitle, stationTitle
     }*/
}

enum CountryType: String {
    case country = "countryTitle"
    case city = "cityTitle"
}

