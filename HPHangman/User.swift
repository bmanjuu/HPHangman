//
//  User.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class User: Object {
    
    dynamic var name: String = ""
    dynamic var gringottsAccount: GringottsAccount?
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    init(name: String, gringottsAccount: GringottsAccount) {
        super.init()
        
        self.name = name
        self.gringottsAccount = gringottsAccount
    }
}
