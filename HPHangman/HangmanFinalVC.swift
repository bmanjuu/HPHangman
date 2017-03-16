//
//  HangmanFinalVC.swift
//  HPHangman
//
//  Created by Betty Fung on 3/11/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import UIKit
import RealmSwift

class HangmanFinalVC: UIViewController {
    
    var endGame: Game!

    @IBOutlet weak var finalImage: UIImageView!
    @IBOutlet weak var aurorModeResultLabel: UILabel!
    @IBOutlet weak var aurorModeResultText: UILabel!
    @IBOutlet weak var userFinalGringottsBalance: UILabel!
    @IBOutlet weak var startOverButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startOverButton.layer.cornerRadius = 6

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if endGame.wonGameStatus {
            BackgroundMusic.playSong("finalVictory")
            self.finalImage.image = UIImage(named: "raiseWands")
            self.aurorModeResultLabel.text = "✨ The End ✨"
            self.aurorModeResultText.text = "We are only as strong as we are united, as weak as we are divided. \nYou have fought valiantly alongside us, \(endGame.player!.name)... Thank you."
        } else {
            BackgroundMusic.playSong("aurorModeLose")
            self.finalImage.image = UIImage(named: "battleContinues")
            self.aurorModeResultLabel.text = "... The war continues ..."
            self.aurorModeResultText.text = "It is important to fight and fight again, and keep fighting, for only then can evil be kept at bay though never quite eradicated."
            //It is the unknown we fear when we look upon death and darkness. Nothing more.
            //We must try not to sink beneath our anguish... but battle on.
        }
        
        let playerGringottsAccount = endGame.player!.gringottsAccount!
        self.userFinalGringottsBalance.text = "\(playerGringottsAccount.galleons)\n\(playerGringottsAccount.sickles)\n\(playerGringottsAccount.knuts)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? HomeScreenVC
        //SHOULD MODIFY HOME SCREEN A LITTLE HERE SO USER DOESNT HAVE TO INPUT THEIR NAME AGAIN 
    }
    

}
