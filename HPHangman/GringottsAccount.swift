//
//  GringottsAccount.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation

class GringottsAccount {
    let owner: User
    var balance: [String:Int]
    
    init(owner: User, balance: [String:Int]) {
        self.owner = owner
        self.balance = balance
    }
}
