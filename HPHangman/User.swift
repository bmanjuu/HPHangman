//
//  User.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation

class User {
    let name: String
    let gringottsAccount: GringottsAccount
    
    init(name: String, gringottsAccount: GringottsAccount) {
        self.name = name
        self.gringottsAccount = gringottsAccount
    }
}
