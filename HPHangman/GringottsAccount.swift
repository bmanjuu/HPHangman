//
//  GringottsAccount.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class GringottsAccount: Object {
    
//    enum money {
//        case galleons, sickles, knuts
//    }
    
    dynamic var owner: User?
    dynamic var galleons: Int = 0
    dynamic var sickles: Int = 0
    dynamic var knuts: Int = 0
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    init(owner: User, galleons: Int, sickles: Int, knuts: Int) {
        super.init()
        
        self.owner = owner
        self.galleons = galleons
        self.sickles = sickles
        self.knuts = knuts
    }
    
}
