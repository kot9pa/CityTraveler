//
//  DetailViewController.swift
//  CityTraveler
//
//  Created by Konstantin on 16.11.2017.
//  Copyright © 2017 Konstantin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dataModel: LocationModelController!
    var tableData = [Station]()
    //typealias Station = LocationModel.Station
    
    private struct Constant {
        static let UnwindSegueToSchedule = "UnwindSegueToSchedule"
        static let StationCell = "stations"
        static let CityFrom = "citiesFrom"
        static let CityTo = "citiesTo"
    }
    
    var countryTitle: String = "" {
        didSet {
            countryLabel?.text = countryTitle
        }
    }
    var cityTitle: String = "" {
        didSet {
            cityLabel?.text = cityTitle
        }
    }

    // MARK: Outlets
    
    @IBOutlet weak var countryLabel: UILabel! {
        didSet {
            countryLabel.text = countryTitle
        }
    }
    @IBOutlet weak var cityLabel: UILabel! {
        didSet {
            cityLabel.text = cityTitle
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableData = dataModel.filteredStations
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.StationCell, for: indexPath)
        
        cell.textLabel?.text = tableData[indexPath.row].stationTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let route = dataModel.route {
            switch route {
            case Constant.CityFrom:
                dataModel.currentStationFrom = tableData[indexPath.row].stationTitle
            case Constant.CityTo:
                dataModel.currentStationTo = tableData[indexPath.row].stationTitle
            default:
                break
            }
        }
        
        performSegue(withIdentifier: Constant.UnwindSegueToSchedule, sender: self)
        
    }


}
