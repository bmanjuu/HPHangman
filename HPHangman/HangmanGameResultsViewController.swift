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
        
        setupMusicFor(gameStatus)
        setupViewsFor(gameStatus)
        
    }
    
    
    @IBAction func playAgainButtonTapped(_ sender: Any) {
        
        if game.currentLevel == 14 {
            self.performSegue(withIdentifier: "finalSegue", sender: nil)
        } else {
            self.performSegue(withIdentifier: "playAgain", sender:nil)
        }
        
    }
    
    func setupMusicFor(_ gameWonStatus: Bool) {
        
        if gameWonStatus {
            switch game.currentLevel {
            case 11...13:
                BackgroundMusic.playSong("aurorModeTransition")
            case 14:
                BackgroundMusic.playSong("aurorModeWin")
            default:
                BackgroundMusic.playSong("Win")
            }
        } else {
            BackgroundMusic.playSong("Lose")
        }
    }
    
    
    func setupViewsFor(_ gameWonStatus: Bool) {
        
        let userGringottsAccount = game.player!.gringottsAccount!
        self.playAgainButton.setTitle("I'm ready!", for: .normal) //default button text
        
        if gameWonStatus {
            //WON GAME
            self.resultsImage.image = UIImage(named: "hpWonGame")
            
            switch game.currentLevel {
            case 10:
                self.resultsExclamationLabel.text = "HOORAY! 🎉"
                self.resultsTextLabel.text = "You helped Harry escape the Deatheaters! \nThere's only one more left... \n\nReady?"
            case 11: //entering level 11
                self.resultsExclamationLabel.text = "YA--Oh, that feels odd..."
                self.resultsTextLabel.text = "Is it just me, or do you feel that too \(game.player!.name)? \nHave your wand ready..."
                self.playAgainButton.setTitle("Got it", for: .normal)
            case 12:
                self.resultsImage.image = UIImage(named: "findNagini")
                self.resultsExclamationLabel.text = "Phew, that was close..."
                //mention chocolate?
                self.resultsTextLabel.text = "I think I saw Nagini slithering in the shadows over there... \nWe have to find her, she'll lead us to Voldemort"
                self.playAgainButton.setTitle("Let's go", for: .normal)
            case 13:
                self.resultsImage.image = UIImage(named: "harryVSvoldemortPreBattle")
                self.resultsExclamationLabel.text = "We found him"
                self.resultsTextLabel.text = "You know what we need to do next \(self.game.player!.name). \nWhenever you're ready..."
                self.playAgainButton.setTitle("It ends now", for: .normal)
            case 14:
                self.resultsImage.image = UIImage(named: "harryVictory")
                self.resultsExclamationLabel.text = "... YOU DID IT"
                self.resultsTextLabel.text = "You've proved to be an incredible Auror, \(game.player!.name). \nVoldemort is gone and the Deatheaters will be charged for their crimes."
                self.playAgainButton.setTitle("Next", for: .normal)
            default: //levels 1-9
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
