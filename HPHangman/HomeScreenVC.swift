//
//  HomeScreenVC.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import UIKit

class HomeScreenVC: UIViewController {

    let store = GameDataStore.sharedInstance

    @IBAction func enterButton(_ sender: Any) {
        //MAKE SURE TO HAVE AN ANIMATION WHILE THE WORDS ARE LOADING
        print("button: \(self.store.words.count)")
        print(HangmanGameLogic.retrieveRandomWord(from: self.store.words))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.store.populateWordsInStore()
        
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
