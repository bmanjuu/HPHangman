//
//  HangmanFinalVC.swift
//  HPHangman
//
//  Created by Betty Fung on 3/11/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import UIKit

class HangmanFinalVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? HomeScreenVC
        //SHOULD MODIFY HOME SCREEN A LITTLE HERE SO USER DOESNT HAVE TO INPUT THEIR NAME AGAIN 
    }
    

}
