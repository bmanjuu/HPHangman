//
//  HomeScreenContainerViewController.swift
//  HPHangman
//
//  Created by Betty Fung on 2/19/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import UIKit

class HomeScreenContainerViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var testing: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("yay container view")
        testing.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
