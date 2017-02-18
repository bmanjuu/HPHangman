//
//  HangmanGameResultsViewController.swift
//  HPHangman
//
//  Created by Betty Fung on 2/17/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class HangmanGameResultsViewController: UIViewController {
    
    public var gameStatus: Bool?
    
    @IBOutlet weak var resultsImage: UIImageView!
    @IBOutlet weak var resultsTextLabel: UILabel!
    @IBOutlet weak var displayWinningsLabel: UILabel!
    @IBOutlet weak var userGringottsBalanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad: PRESENTING RESULTS VC!")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //pass information about win/loss here 
        self.resultsTextLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.displayWinningsLabel.isHidden = true
        
        let realm = try! Realm()
        gameStatus = HangmanGameLogic.retrieveCurrentGame().wonGame
        let userGringottsAccount = HangmanGameLogic.retrieveCurrentGame().player!.gringottsAccount!
        
        self.userGringottsBalanceLabel.text = "galleons: \(userGringottsAccount.galleons), sickles: \(userGringottsAccount.sickles), knuts: \(userGringottsAccount.knuts)"
        
        //depending on the status, display different images, text and maybe music?
        if gameStatus! {
            // show winning picture and text
            self.resultsImage.image = UIImage(named: "hpCastleImage")
            self.resultsTextLabel.text = "HOORAY!\n You saved Harry and the Wizarding World from the wrath of Lord Voldemort!\n The Ministry has rewarded you with: "
            self.displayWinningsLabel.isHidden = false
            self.displayWinningsLabel.text = "galleons: \(userGringottsAccount.galleons), sickles: \(userGringottsAccount.sickles), knuts: \(userGringottsAccount.knuts)"
        } else {
            // show losing picture and ask to try again
            self.resultsImage.image = UIImage(named: "hpLostGame")
            self.resultsTextLabel.text = "Oh no!\n Voldemort got a hold of Harry!\n You still have another chance to save him! Would you like to play again?"
        }
        
    }
    
    @IBAction func playAgainButtonTapped(_ sender: Any) {
        //reset everything
        //segue back to other vc
        //retrieve new word
    }

    @IBAction func exitButtonTapped(_ sender: Any) {
        //segue to conclusion/thank you view controller
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
