//
//  ViewController.swift
//  SwiftPodsSample
//
//  Created by Vitaly Sokolov on 12.08.2020.
//

import UIKit
import Segment

class ViewController: UIViewController {
    var eventValues = [String:Any]()
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var key: UITextField!
    @IBOutlet weak var value: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK:- IBActions
    @IBAction func addValue(_ sender: Any) {
        if let text = key.text {
            eventValues[text] = value.text ?? ""
        }
    }
    
    
    @IBAction func sendEvent(_ sender: Any) {
        if let event = eventName.text {
            Analytics.shared().track(event, properties: eventValues)
        }
        
    }
    
}

