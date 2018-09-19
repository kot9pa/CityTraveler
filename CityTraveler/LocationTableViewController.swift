//
//  LocationTableViewController.swift
//  CityTraveler
//
//  Created by Konstantin on 15.11.2017.
//  Copyright © 2017 Konstantin. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController, UISearchBarDelegate {
   
    // MARK: - Properties

    @IBOutlet weak var searchRouteBar: UISearchBar!
    
    var route: String?
    var dataModel: LocationModelController!
    private var filters = [LocationFilter]()
    private var tableData = [Country]()
    
    private struct Constant {
        static let StationCell = "station"
        static let DetailSegue = "from location"
        static let CityFrom = "citiesFrom"
        static let CityTo = "citiesTo"
    }
    
    private enum LocationFilter {
        case country(country: String)
        case city(city: String)
        
        func compare(with location: Station) -> Bool {
            switch self {
            case .country(let country):
                return location.countryTitle.lowercased().contains(country.lowercased())
            case .city(let city):
                return location.cityTitle.lowercased().contains(city.lowercased())
            }
        }
        
        func compare(with location: Country) -> Bool {
            switch self {
            case .country(let country):
                return location.countryTitle.lowercased().contains(country.lowercased())
            case .city(let city):
                return location.cityTitle.lowercased().contains(city.lowercased())
            }
        }
        
    }
    
    private func filterLocations(with filters: [LocationFilter]) {
        switch searchRouteBar.selectedScopeButtonIndex {
        case 0:
            tableData = dataModel.currentLocations.filter { location in
                guard let array = filters.first else { return false }
                var result = true
                if !array.compare(with: location) {
                    result = false
                }
                return result
            }
        case 1:
            tableData = dataModel.currentLocations.filter { location in
                guard let array = filters.last else { return false }
                var result = true
                if !array.compare(with: location) {
                    result = false
                }
                return result
            }
        default:
            break
        }
//        let temp = dataModel.currentLocations.filter { location in
//            guard let array = filters.first else { return false }
//            var result = true
//            if !array.compare(with: location) {
//                result = false
//            }
//            return result
//        }
//
//        if temp.count != dataModel.currentLocations.count {
//            tableData = dataModel.currentLocations.filter { location in
//                guard let array = filters.last else { return false }
//                var result = true
//                if !array.compare(with: location) {
//                    result = false
//                }
//                return result
//            }
//        } else { tableData = temp }
        
        //print(dataModel.currentLocations.count)
        //print(temp.count)
        //dump(tableData)
    }
    
    private func filterStations(with filters: [LocationFilter]) {
        let data = dataModel.currentStations.filter { station in
            var result = true
            filters.forEach { filter in
                //print(station.stations.count)
                if !filter.compare(with: station) {
                    result = false
                }
            }
            return result
        }
        
        dataModel.filteredStations = data
        //dump(dataModel.filteredStations)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableData = dataModel.currentLocations
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if let route = dataModel.route {
//            switch route {
//            case Constant.CityFrom:
//                if let stationFrom = dataModel.currentStationFrom {
//                    searchRouteBar.text = stationFrom
//                }
//            case Constant.CityTo:
//                if let stationTo = dataModel.currentStationTo {
//                    searchRouteBar.text = stationTo
//                }
//            default:
//                break
//            }
//        }

    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.StationCell, for: indexPath)
        
        cell.textLabel?.text = tableData[indexPath.row].countryTitle
        cell.detailTextLabel?.text = tableData[indexPath.row].cityTitle
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filters = [LocationFilter.country(country: tableData[indexPath.row].countryTitle),
                       LocationFilter.city(city: tableData[indexPath.row].cityTitle)]
        
        filterStations(with: filters)
        shouldPerformSegue(withIdentifier: Constant.DetailSegue, sender: self)
        
    }
    
    // MARK: - UISearchBar
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let text = searchBar.text?.isEmpty, !text else {
            tableData = dataModel.currentLocations
            tableView.reloadData()
            searchBar.resignFirstResponder()
            return
        }
        switch selectedScope {
        case 0...1:
            filterLocations(with: filters)

        default:
            break
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            tableData = dataModel.currentLocations
            tableView.reloadData()
            return
        }
        
        filters = [LocationFilter.country(country: searchText),
                       LocationFilter.city(city: searchText)]
        
        filterLocations(with: filters)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.isEmpty, !text else {
            tableData = dataModel.currentLocations
            tableView.reloadData()
            searchBar.resignFirstResponder()
            return
        }
        filterLocations(with: filters)
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            switch identifier {
            case Constant.DetailSegue:
                if let dvc = segue.destination as? DetailViewController,
                    let cell = sender as? UITableViewCell,
                    let country = cell.textLabel?.text,
                    let city = cell.detailTextLabel?.text {
                    
                    dvc.countryTitle = country
                    dvc.cityTitle = city
                    dvc.dataModel = dataModel
                }
            default: break
            }
        }
    }
}

