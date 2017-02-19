//
//  LaunchScreenViewController.swift
//  HPHangman
//
//  Created by Betty Fung on 2/19/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class LaunchScreenViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialTextField.becomeFirstResponder()
        self.initialTextField.resignFirstResponder()
        print("done setting up textfield stuff")
        
        //timer for 1.5 seconds before segue-ing to the welcome screen 

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var initialTextField: UITextField!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let destination = segue.destination as? HomeScreenVC
        destination?.name = initialTextField.text! 
    }
    

}
