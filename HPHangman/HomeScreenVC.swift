//
//  HomeScreenVC.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import UIKit
import RealmSwift
import NVActivityIndicatorView

class HomeScreenVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var muggleGreetings: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var welcomeToHogwarts: UIImageView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var readyButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var storylineView: UIView!
    @IBOutlet weak var storyText: UILabel!
    
    var newGame : Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        self.setupWelcomeScreen()
        self.prepareToStartGame()
        
    }
    
    @IBAction func enterButtonTapped(_ sender: Any) {
        
        self.usernameTextField.resignFirstResponder()
        
        if usernameTextField.text!.isEmpty {
            self.present(HangmanAlerts.enterName(), animated: true, completion: nil)
        } else {
            self.nameLabel.text = "\(usernameTextField.text!.capitalized),"
            
            let realm = try! Realm()
            try! realm.write {
                self.newGame!.player!.name = usernameTextField.text!.capitalized
            }
            
            self.revealStoryline()
        }

    }

    func setupWelcomeScreen() {
        self.storylineView.isHidden = true
        self.readyButton.layer.cornerRadius = 6
        
        self.muggleGreetings.adjustsFontSizeToFitWidth = true
        self.muggleGreetings.minimumScaleFactor = 0.5
        self.muggleGreetings.text = "Greetings, dear friend. \nWe've been expecting you..."
        
        self.enterButton.titleLabel?.minimumScaleFactor = 0.5
        self.enterButton.titleLabel?.numberOfLines = 0
        self.enterButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.enterButton.layer.cornerRadius = 6
        
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
        
        self.newGame = game
        self.newGame!.populateWordsInStore()
    }
    
    func revealStoryline() {
        self.muggleGreetings.isHidden = true
        self.usernameTextField.isHidden = true
        self.enterButton.isHidden = true
        
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.storyText.text = "Voldemort is back. \n\n You have been chosen to help Harry in his fight against the Dark Lord through a perilous game of Hangman. \n\nBe careful though! With each incorrect guess, Voldemort gets closer to capturing Harry and taking over the wizarding world. \n\nWe're counting on you!"
        self.storylineView.isHidden = false
        
        // song has to be here b/c its when user is done with textfield. loading the keyboard for the first time tends to interrupt the music
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
    
    
// MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        self.storylineView.isHidden = true
        
        //setting up an activity indicator in case words aren't fully populated in the newGame yet. In most cases, this won't show up
        let loadingActivityIndicatorView = NVActivityIndicatorView(frame: self.view.frame, type: .ballClipRotate, color: UIColor.white, padding: 0.0)
        let destinationVC = segue.destination as? HangmanGameVC
        
        self.view.addSubview(loadingActivityIndicatorView)
        loadingActivityIndicatorView.startAnimating()
        
        while !(newGame!.finishedPopulatingWordsForGame) {
            print("waiting to retrieve words")
        }
        
        loadingActivityIndicatorView.stopAnimating()
        
        destinationVC?.game = self.newGame!
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
