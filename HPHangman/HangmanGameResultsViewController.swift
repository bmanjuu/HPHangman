//
//  HangmanGameResultsViewController.swift
//  HPHangman
//
//  Created by Betty Fung on 2/17/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import UIKit
import RealmSwift

class HangmanGameResultsViewController: UIViewController {
    
    var game: Game!
    
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var resultsImage: UIImageView!
    @IBOutlet weak var resultsExclamationLabel: UILabel!
    @IBOutlet weak var resultsTextLabel: UILabel!
    @IBOutlet weak var displayWinningsLabel: UILabel!
    @IBOutlet weak var moneyResultsLabel: UILabel!
    @IBOutlet weak var wizardingDenominationsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playAgainButton.layer.cornerRadius = 6
        
        adjustButtonFontSize()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let gameStatus = game.wonGameStatus
        
        if gameStatus {
            BackgroundMusic.playSong("Win")
        } else {
            BackgroundMusic.playSong("Lose")
        }
 
        setupViewsFor(gameStatus)
        
    }
    
    
    @IBAction func playAgainButtonTapped(_ sender: Any) {
        if game.finalLevelStreak < 3 {
            self.performSegue(withIdentifier: "playAgain", sender:nil)
        } else {
            self.performSegue(withIdentifier: "finalSegue", sender: nil)
        }
        
    }
    
    
    func setupViewsFor(_ gameWonStatus: Bool) {
        
        let userGringottsAccount = game.player!.gringottsAccount!
        self.playAgainButton.setTitle("I'm ready!", for: .normal) //default button text
        
        if gameWonStatus {
            self.resultsImage.image = UIImage(named: "hpWonGame")
            
//            switch game.currentLevel {
//            case 10:
//            case 11:
//                
//            }
            if game.currentLevel == 11 {
                switch game.finalLevelStreak {
                    //music options: 
                    // sound effect: horror - ambient hum pitched, hallow wind
                    
                case 0: //streak 1 
                    self.resultsExclamationLabel.text = "HEAR YE, HEAR YE! 🎉"
                    self.resultsTextLabel.text = "Have you considered becoming an Auror, \(game.player!.name)? You'd be great! \n\nBut wait... do you feel that?"
                    self.playAgainButton.setTitle("What?", for: .normal)
                    //dementors -- sound when pressed: swoosh from sound effects
                    //OPTION: answer should always be expecto patronum
                case 1: //streak 2, after defeating dementors
                    self.resultsExclamationLabel.text = "Phew, that was close..."
                    self.resultsTextLabel.text = "I think I saw Nagini slithering in the shadows over there... \nWe have to find her, she'll lead us to Voldemort"
                    self.playAgainButton.setTitle("Let's go", for: .normal)
                    //nagini
                case 2: //streak 3, after defeating nagini
                    self.resultsExclamationLabel.text = "Goodbye Nagini"
                    self.resultsTextLabel.text = "You know what we need to do next, \nright \(self.game.player!.name)? \nWhenever you're ready..."
                    self.playAgainButton.setTitle("It ends now", for: .normal)
                    //voldemort
                case 3: //streak 4, after defeating voldemort
                    self.resultsExclamationLabel.text = "... YOU DID IT"
                    self.resultsTextLabel.text = "You've helped Harry vanquish the Dark Lord once and for all. \nThe Wizarding World is indebted to you, \(game.player!.name)!"
                    self.playAgainButton.setTitle("Next", for: .normal)
                default:
                    self.resultsExclamationLabel.text = "HEAR YE, HEAR YE! 🎉"
                    self.resultsTextLabel.text = "We have a champion Auror amongst us! Harry and the Wizarding World are indebted to you... \nWould you like to play again?"
                }
            } else {
                self.resultsExclamationLabel.text = "HOORAY! 🎉"
                self.resultsTextLabel.text = "You helped Harry escape the Deatheaters! \nBut the battle is far from over... \n\nReady for the next level?"
            }
            
            self.moneyResultsLabel.text! = "The Ministry of Magic has awarded you with:"
            self.displayWinningsLabel.text = "\(game.galleonsEarned)\n\(game.sicklesEarned)\n\(game.knutsEarned)"
        } else {
            self.resultsImage.image = UIImage(named: "hpLostGame")
            self.resultsExclamationLabel.text = "AHHHHH! 😱"
            self.resultsTextLabel.text = "Voldemort got a hold of Harry! \nYou still have another chance to save him! \nWould you like to play again?"
            self.moneyResultsLabel.text! = "Your Gringott's balance is currently:"
            self.displayWinningsLabel.text = "\(userGringottsAccount.galleons)\n\(userGringottsAccount.sickles)\n\(userGringottsAccount.knuts)"
        }
        
    }
    
    func adjustButtonFontSize() {
        self.playAgainButton.titleLabel?.minimumScaleFactor = 0.5
        self.playAgainButton.titleLabel?.numberOfLines = 0
        self.playAgainButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        BackgroundMusic.stopPlayingSong()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let realm = try! Realm()
        
        if segue.identifier == "playAgain" {
            let destinationVC = segue.destination as? HangmanGameVC
            
            //reset current game values and pass that back to the game property of HangmanGameVC
            try! realm.write {
                game.guessesSoFar = ""
                game.incorrectGuessCount = 0
                game.wonGameStatus = false
            }
            
            destinationVC?.game = game
        } else {
            let destinationVC = segue.destination as? HangmanFinalVC
            destinationVC?.endGame = game
        }
        
    }
 

}
