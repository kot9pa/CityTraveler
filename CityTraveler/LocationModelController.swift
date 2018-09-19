//
//  LocationModelController.swift
//  CityTraveler
//
//  Created by Konstantin on 15.11.2017.
//  Copyright © 2017 Konstantin. All rights reserved.
//

import Foundation

class LocationModelController {

    // MARK: - Properties
    
    var currentLocations = [Country]()
    var filteredStations = [Station]()
    var currentStations = [Station]()
    
    var currentStationFrom: String?
    var currentStationTo: String?
    var route: String?
    
    private struct Constant {
        static let JSONName = "allStations"
        static let CityFrom = "citiesFrom"
        static let CityTo = "citiesTo"
        
    }
    
    func parseJSON(with route: String?) {
        var arrayForJoined = [[Station]]()
        let filePath = Bundle.main.path(forResource: Constant.JSONName, ofType: "json")
        let url = URL(fileURLWithPath: filePath!)
        //let web = "http://localhost:3000/db"
        //let url = URL(string: web)!
        let data = try! Data(contentsOf: url, options: .uncached)
        
        let decoder = JSONDecoder()
        do {
            let decodeLocation = try decoder.decode(Location.self, from: data)
            if let route = route {
                self.currentLocations = (route == Constant.CityFrom) ?
                    decodeLocation.citiesFrom:decodeLocation.citiesTo

                print("Parse OK")
            }
        } catch let error {
            print("Failed to convert data \(error)")
        }
        //dump(currentLocations)
        currentLocations.forEach({ location in
            arrayForJoined.append(location.stations)
        })
        currentStations = Array(arrayForJoined.joined())
        //dump(currentStations)
        
    }

}
