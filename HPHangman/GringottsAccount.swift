//
//  GringottsAccount.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation

class GringottsAccount {
    
    enum money {
        case galleons, sickles, knuts
    }
    
    let owner: User
    var balance: [money:Int] = [.galleons : 0,
                                .sickles : 0,
                                .knuts : 0]
    
    init(owner: User, balance: [money:Int]) {
        self.owner = owner
        self.balance = balance
    }
    
    convenience init(owner: User) {
        self.init(owner: owner, balance: [.galleons : 0,
                                          .sickles : 0,
                                          .knuts : 0])
    }
    
}
