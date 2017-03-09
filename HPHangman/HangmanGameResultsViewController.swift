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
    
    var finishedGame: Game!
    
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var resultsImage: UIImageView!
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
        
        let gameStatus = finishedGame.wonGameStatus
        
        if gameStatus {
            BackgroundMusic.playSong("Win")
        } else {
            BackgroundMusic.playSong("Lose")
        }
 
        setupViewsFor(gameStatus)
        
    }
    
    
    @IBAction func playAgainButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "playAgain", sender:nil)
    }
    
    
    func setupViewsFor(_ gameWonStatus: Bool) {
        
        let userGringottsAccount = finishedGame.player!.gringottsAccount!
        
        if gameWonStatus {
            self.resultsImage.image = UIImage(named: "hpWonGame")
            
            if finishedGame.currentLevel == 10 {
                self.resultsTextLabel.text = "HEAR YE, HEAR YE! 🎉\nWe have a champion amongst us! You've emerged from this epic battle victoriously and Harry and the Wizarding World are indebted to you."
            } else {
                self.resultsTextLabel.text = "HOORAY! 🎉\nYou saved Harry and the Wizarding World from the wrath of Lord Voldemort!"
            }
            
            self.moneyResultsLabel.text! = "The Ministry of Magic has awarded you with:"
            self.displayWinningsLabel.text = "\(finishedGame.galleonsEarned)\n\(finishedGame.sicklesEarned)\n\(finishedGame.knutsEarned)"
        } else {
            self.resultsImage.image = UIImage(named: "hpLostGame")
            self.resultsTextLabel.text = "AHHHHH! 😱\nVoldemort got a hold of Harry! \nYou still have another chance to save him! \nWould you like to play again?"
            self.moneyResultsLabel.text! = "Your Gringott's balance is currently:"
            self.displayWinningsLabel.text = "\(userGringottsAccount.galleons)\n\(userGringottsAccount.sickles)\n\(userGringottsAccount.knuts)"
        }
        
        let upcomingLevel = finishedGame.currentLevel //we already increased/decreased a level in the wonGame and lostGame functions of Game 
        if upcomingLevel < 10 {
            self.playAgainButton.titleLabel?.text = "Next"
            //next also doesn't seem right to put here... need to think of a better way to transition into the next game         
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
        let destinationVC = segue.destination as? HangmanGameVC
        
        //reset current game values and pass that back to the game property of HangmanGameVC
        let realm = try! Realm()
        try! realm.write {
            finishedGame.guessesSoFar = ""
            finishedGame.incorrectGuessCount = 0
            finishedGame.wonGameStatus = false
        }
        
        destinationVC?.game = finishedGame
    }
 

}
