//
//  ScheduleViewController.swift
//  CityTraveler
//
//  Created by Konstantin on 17.11.2017.
//  Copyright © 2017 Konstantin. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var stationFromField: UITextField!
    @IBOutlet weak var stationToField: UITextField!
    @IBOutlet weak var scheduleDate: UIDatePicker!
    @IBOutlet weak var changeButton: UIButton!
    
    @IBAction func unwindToSchedule(segue:UIStoryboardSegue) { }
    @IBAction func changeRoute(_ sender: UIButton) {
        if let stationFrom = dataModel.currentStationFrom,
            let stationTo = dataModel.currentStationTo {
            stationFromField.text = stationTo
            stationToField.text = stationFrom
            dataModel.currentStationFrom = stationTo
            dataModel.currentStationTo = stationFrom
        } else { showAlert() }
        
        animateButton(with: sender)
    }
    
    @IBAction func buyTicket(_ sender: UIButton) {
        animateButton(with: sender)
    }
    
    var dataModel: LocationModelController!
    
    public struct Constant {
        static let SegueFromSchedule = "from schedule"
        static let CityFrom = "citiesFrom"
        static let CityTo = "citiesTo"
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == stationFromField {
            dataModel.route = Constant.CityFrom
        } else {
            dataModel.route = Constant.CityTo
        }
        chooseLocation()
        return false
    }
    
    private func chooseLocation() {
        DispatchQueue.global(qos: .userInitiated).async {
            // Some background work here
            self.dataModel.parseJSON(with: self.dataModel.route)
            
            DispatchQueue.main.async {
                // It's time to update the UI
                self.performSegue(withIdentifier: Constant.SegueFromSchedule, sender: self.self )
                print("UI updated on main queue")
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Warning!", message: "Please select locations FROM/TO.", preferredStyle: .alert)
        let buttonOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        let buttonOK = UIAlertAction(title: "OK", style: .default, handler: { action in
//            self.chooseLocation()})

        alert.addAction(buttonOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func animateButton(with button: UIButton) {
        button.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        button.transform = CGAffineTransform.identity
        },
                       completion: { void in()  }
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let route = dataModel.route {
            switch route {
            case Constant.CityFrom:
                if let station = dataModel.currentStationFrom {
                    stationFromField.text = station
                }
            case Constant.CityTo:
                if let station = dataModel.currentStationTo {
                    stationToField.text = station
                }
            default:
                break
            }
        }
        
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constant.SegueFromSchedule:
                if let ltvc = segue.destination as? LocationTableViewController {
                    ltvc.dataModel = dataModel
                }
            default: break
            }
        }
    }
    
}
