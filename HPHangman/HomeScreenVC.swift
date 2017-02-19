//
//  HomeScreenVC.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import UIKit
import RealmSwift

class HomeScreenVC: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func enterButton(_ sender: Any) {
        //display storyline here
        //then when user presses enter again, ask for name or just go into game
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.usernameTextField.becomeFirstResponder()
        self.usernameTextField.resignFirstResponder()
        
        let realm = try! Realm()
        let user = User()
        let userGringottsAccount = GringottsAccount()
        let game = Game()
        
        user.gringottsAccount = userGringottsAccount
        game.player = user
        
        try! realm.write {
            realm.add(game)
            realm.add(user)
            realm.add(userGringottsAccount)
        }
        
        HangmanGameLogic.populateWordsInStore()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        BackgroundMusic.playSong("Intro")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        BackgroundMusic.stopPlayingSong()
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
