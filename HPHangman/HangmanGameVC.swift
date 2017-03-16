//
//  HangmanGameVC.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import UIKit
import RealmSwift

class HangmanGameVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userCurrentLevelLabel: UILabel!
    @IBOutlet weak var duelLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var hangmanImage: UIImageView!
    @IBOutlet weak var secretWordLabel: UILabel!
    @IBOutlet weak var guessesLabel: UILabel!
    @IBOutlet weak var chancesLabel: UILabel!
    @IBOutlet weak var knutsBalance: UILabel!
    @IBOutlet weak var sicklesBalance: UILabel!
    @IBOutlet weak var galleonsBalance: UILabel!
    @IBOutlet weak var stormyBackgroundImage: UIImageView!
    @IBOutlet weak var flashRedView: UIImageView!
    
    @IBOutlet weak var guessButton: UIButton!
    @IBOutlet weak var buyALetterButton: UIButton!
    
    var game: Game!
    var displayAlert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        self.scrollView.autoresizesSubviews = false 
        self.hideKeyboardWhenTappedAround()
        userInput.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.setupMusic()
        self.startGame()
        self.setupViewForGame()
    }
    
    
    @IBAction func guessButtonTapped(_ sender: Any) {
        self.userInput.resignFirstResponder()
        let incorrectGuessCountBeforeTurn = game.incorrectGuessCount
        
        let validInput = game.isValidInput(userInput.text!, from: self)
        
        guard validInput else { userInput.text = ""; return }
        
        game.playGame(with: userInput.text!)
        self.guessesLabel.text = game.guessesSoFar
        self.chancesLabel.text = "\(6-game.incorrectGuessCount)"
        self.secretWordLabel.text = game.concealedWord.replacingOccurrences(of: "+", with: "    ")
        self.updateDuelLabel(incorrectGuessCount: game.incorrectGuessCount)
        
        if game.incorrectGuessCount > incorrectGuessCountBeforeTurn {
            
            //flash red and shake animation
            UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveEaseInOut, animations: {
                // added a slightly transparent red imageview over the harry potter duel image that will fade in and out
                self.flashRedView.alpha = 0.3
                self.incorrectGuessShakeAnimation() //image shakes as flashRedView appears and fades
                self.flashRedView.alpha = 0.0
                
                //changing the tintColor of the image does not work in this situation because it permanently alters the state of the image so that the entire image view is an opaque red box. trying to restore the original tintColor by setting it equal to nil or clear makes the imageView blue or completey transparent (so the picture of Harry also disappears) respectively
                /*
                self.hangmanImage.image = self.hangmanImage.image!.withRenderingMode(.alwaysTemplate)
                self.hangmanImage.tintColor = UIColor.red
                self.hangmanImage.tintColor = UIColor.clear
                */
                
                self.hangmanImage.alpha -= 0.19
            }, completion: nil)
        }
        
        if game.wonGameStatus {
            self.secretWordLabel.textColor = UIColor.green
            displayAlert = HangmanAlerts.endGameAlert(wonGameStatus: true, chosenWord: game.chosenWord)
            //handle segue to final VC if user is in auror mode here
        } else if game.incorrectGuessCount == 6 {
            self.secretWordLabel.textColor = UIColor.red
            displayAlert = HangmanAlerts.endGameAlert(wonGameStatus: false, chosenWord: game.chosenWord)
        }
        
        if displayAlert != nil {
            let okButtonTapped = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                
                if self.game.currentLevel < 11 || (self.game.currentLevel > 10 && self.game.currentLevel <= 14 && self.game.wonGameStatus) {
                    //segue to results VC if user is not in auror mode, otherwise, only segue if the user has won a game
                    self.performSegue(withIdentifier: "showResults", sender:nil)
                } else if (self.game.currentLevel > 10 && self.game.currentLevel <= 14) && !self.game.wonGameStatus {
                    //if the user loses a game during auror mode, they will go to the final screen and will need to start over
                    self.performSegue(withIdentifier: "showFinal", sender: nil)
                } 
            }
            
            displayAlert!.addAction(okButtonTapped)
            self.present(displayAlert!, animated: true, completion: nil)
        }
        
        userInput.text = ""
    }
    
    
    @IBAction func buyALetterButtonTapped(_ sender: Any) {
        print("buy a letter button tapped")
        let userGringottsAccount = game.player!.gringottsAccount!
        
        if game.hasSufficientFunds() {
            print("has sufficient funds")
            game.revealRandomLetter()
            
            self.secretWordLabel.text = game.concealedWord
            self.galleonsBalance.text = "\(userGringottsAccount.galleons)"
            self.sicklesBalance.text = "\(userGringottsAccount.sickles)"
            self.knutsBalance.text = "\(userGringottsAccount.knuts)"
            
            //if buying/revealing the last letter, user wins game
            guard game.wonGameStatus else { return }
            
            self.secretWordLabel.textColor = UIColor.green
            displayAlert = HangmanAlerts.endGameAlert(wonGameStatus: true, chosenWord: game.chosenWord)
            if displayAlert != nil {
                let okButtonTapped = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    print("ok tapped")
                    self.performSegue(withIdentifier: "presentResultsVC", sender: nil)
                }
                
                displayAlert!.addAction(okButtonTapped)
                self.present(displayAlert!, animated: true, completion: nil)
            }
            
        } else {
            self.present(HangmanAlerts.insufficientFundsAlert(price: game.priceOfLetter), animated: true, completion: nil)
        }
    }

    
    func startGame() {
        game.retrieveRandomWord(currentLevel: game.currentLevel)
    }
    
    func setupViewForGame() {
        
        self.scrollView.alwaysBounceVertical = false
        self.duelLabel.adjustsFontSizeToFitWidth = true
        
        switch game.currentLevel {
        case 11: //dementors
            self.duelLabel.text = "A dementor--stay strong, \(game.player!.name)!"
            self.hangmanImage.image = UIImage(named: "dementor")
        case 12: //nagini
            self.duelLabel.text = "Found her!! Don't let her escape!"
            self.hangmanImage.image = UIImage(named: "nagini")
        case 13: //voldemort
            self.duelLabel.text = "I'm with you, \(game.player!.name)!"
            self.hangmanImage.image = UIImage(named: "harryVSvoldemortBattle")
        default: //text and image for levels 1-10
            self.duelLabel.text = "Oh no... it's Deatheaters! Time to duel!"
            self.hangmanImage.image = UIImage(named: "hpBattleImage")
        }
        
        self.flashRedView.alpha = 0.0
        //add gradient to the view so that the edges visually blend into everything better
        let blurGradient = CAGradientLayer()
        blurGradient.frame = self.flashRedView.bounds
        blurGradient.colors = [UIColor.clear.cgColor, UIColor.red.cgColor, UIColor.red.cgColor,UIColor.clear.cgColor]
        blurGradient.locations = [0.0, 0.06, 0.94, 1.0]
        //I added red to the gradient colors array twice because when it was just three (clear, red, clear), the red would show up as a very pronounced stripe in the middle. Adjusting locations for 3 gradient colors was also a challenge because I could not seem to "stretch" the middle gradient without having the same pronounced stripe effect or having the red gradient only cover the top half of the image (the bottom half would be clear). So I decided that I needed to add a third color for the second color to fade into before it fades back into clear again
        //So for the gradient locations, clear fades into red at 0.6, red transitions into more red at 0.94 (thereby extending the gradient of red), and after that, fades back into clear at the end of the gradient frame
        self.flashRedView.layer.addSublayer(blurGradient)
        
        self.userInput.layer.borderWidth = 1.0
        self.userInput.layer.borderColor = UIColor.blue.cgColor
        self.userInput.layer.cornerRadius = 6
        
        self.secretWordLabel.text = game.concealedWord.replacingOccurrences(of: "+", with: "    ")
        self.guessesLabel.text = game.guessesSoFar
        self.chancesLabel.text = "\(6-game.incorrectGuessCount)"
        self.galleonsBalance.text = "\(game.player!.gringottsAccount!.galleons)"
        self.sicklesBalance.text = "\(game.player!.gringottsAccount!.sickles)"
        self.knutsBalance.text = "\(game.player!.gringottsAccount!.knuts)"
        self.userCurrentLevelLabel.text = "\(game.currentLevel)"
        
        self.guessButton.layer.cornerRadius = 6
        self.buyALetterButton.layer.cornerRadius = 6
        
    }
    
    func setupMusic() {
        switch game.currentLevel {
        case 11:
            BackgroundMusic.playSong("DementorBattle")
        case 12:
            BackgroundMusic.playSong("NaginiBattle")
        case 13:
            BackgroundMusic.playSong("HarryVoldemortBattle")
        default: //music for levels 1-10
            BackgroundMusic.playSong("DuringGameplay")
        }
    }
    
    func incorrectGuessShakeAnimation() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 5
        shake.autoreverses = true
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.hangmanImage.center.x, y: self.hangmanImage.center.y - 4))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.hangmanImage.center.x, y: self.hangmanImage.center.y + 4))
        self.hangmanImage.layer.add(shake, forKey: "position")
        self.flashRedView.layer.add(shake, forKey: "position")
    }
    
    func updateDuelLabel(incorrectGuessCount: Int) {
        
        switch incorrectGuessCount {
        case 1:
            self.duelLabel.text = "Ouch! First hit!"
        case 2:
            self.duelLabel.text = "Be careful!"
        case 3:
            self.duelLabel.text = "Hang in there, \(game.player!.name)!"
            self.duelLabel.textColor = UIColor.yellow
        case 4:
            self.duelLabel.text = "We need to recover, quick!"
            self.duelLabel.textColor = UIColor.orange
        case 5:
            self.duelLabel.text = "It's do or die now -- YOU CAN DO THIS!"
            self.duelLabel.textColor = UIColor.red
        case 6:
            self.duelLabel.text = "Game Over"
        //text color here stays red based on previous case/update of label
        default:
            print("none")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        BackgroundMusic.stopPlayingSong()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//MARK: - Textfield Delegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        DispatchQueue.main.async {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        DispatchQueue.main.async {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.guessButtonTapped(textField)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let inputTextLength = textField.text!.characters.count + string.characters.count
        
        if inputTextLength > game.chosenWord.characters.count {
            return false
        } else {
            return true
        }
    }
    
    
    
// MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResults" {
            let destinationVC = segue.destination as? HangmanGameResultsViewController
            destinationVC?.game = game
        } else {
            let destinationVC = segue.destination as? HangmanFinalVC
            destinationVC?.endGame = game
        }
     }
    
    
}
