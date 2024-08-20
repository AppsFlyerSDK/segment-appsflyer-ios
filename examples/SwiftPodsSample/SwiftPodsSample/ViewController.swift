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
        //Looks for single or multiple taps.
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
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
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}

