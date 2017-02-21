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
    
    @IBOutlet weak var muggleGreetings: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var welcomeToHogwarts: UIImageView!
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var storylineView: UIView!
    @IBOutlet weak var storyText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        self.setupWelcomeScreen()
        self.prepareToStartGame()
        
    }
    
    @IBAction func enterButtonTapped(_ sender: Any) {
        self.usernameTextField.resignFirstResponder()
        
        self.nameLabel.text = "\(usernameTextField.text!.lowercased().capitalized),"
        
        let realm = try! Realm()
        try! realm.write {
            HangmanGameLogic.retrieveCurrentGame().player!.name = usernameTextField.text!
        }
        self.revealStoryline()

    }
    

    func setupWelcomeScreen() {
        self.storylineView.isHidden = true
        self.storyText.text = "Voldemort is back. \n\n You have been chosen to help Harry in his fight against the Dark Lord through a perilous game of Hangman. \n\nBe careful though! With each incorrect guess, Voldemort gets closer to capturing Harry and taking over the wizarding world. \n\nWe're counting on you!"
        self.enterButton.layer.borderColor = UIColor.white.cgColor
        self.enterButton.layer.borderWidth = 1.0
    }
    
    func prepareToStartGame() {
        let realm = try! Realm()
        
        let user = User()
        let game = Game()
        let userGringottsAccount = GringottsAccount()
        
        user.gringottsAccount = userGringottsAccount
        game.player = user
        
        try! realm.write {
            realm.add(user)
            realm.add(userGringottsAccount)
            realm.add(game)
        }
        
        HangmanGameLogic.populateWordsInStore()
    }
    
    func revealStoryline() {
        self.muggleGreetings.isHidden = true
        self.usernameTextField.isHidden = true
        self.enterButton.isHidden = true
        self.storylineView.isHidden = false
        
        //song has to be here b/c its when user is done with textfield
        BackgroundMusic.playSong("Intro")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        self.enterButtonTapped(textField)
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let inputTextLength = textField.text!.characters.count + string.characters.count
        
        if inputTextLength == 0 {
            return false
        } else {
            return true
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
