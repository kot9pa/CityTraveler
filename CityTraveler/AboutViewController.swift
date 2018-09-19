//
//  AboutViewController.swift
//  CityTraveler
//
//  Created by Konstantin on 15.11.2017.
//  Copyright © 2017 Konstantin. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var copyright: UILabel!
    @IBOutlet weak var version: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        copyright.text = "All Right Reserved (c)"
        version.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
