//
//  HomeScreenVC.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import UIKit
import RealmSwift

class HomeScreenVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var welcomeToGryffindor: UIImageView!
    
    @IBOutlet weak var welcomeContainerView: UIView!
    
    @IBAction func alohomoraTapped(_ sender: Any) {
        self.usernameTextField.isHidden = true
        self.welcomeToGryffindor.isHidden = true
        self.welcomeContainerView.isHidden = false
        BackgroundMusic.playSong("Intro")
    }
    
    override func viewDidLoad() {
        print("view did load of welcome screen")
        super.viewDidLoad()
        self.welcomeContainerView.isHidden = true
        
        usernameTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        let realm = try! Realm()
        let user = User()
        let userGringottsAccount = GringottsAccount()
        let game = Game()
        
        user.name = self.usernameTextField.text!
        user.gringottsAccount = userGringottsAccount
        game.player = user
        
        try! realm.write {
            realm.add(game)
            realm.add(user)
            realm.add(userGringottsAccount)
        }
        
        HangmanGameLogic.populateWordsInStore()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
