//
//  Currency.swift
//  Currency Converter
//
//  Created by Giovanny Orozco on 12/12/16.
//  Copyright © 2016 Giovanny Orozco. All rights reserved.
//

import Foundation

struct Currency {
  
    var symbol: String
    var value: Float
    
    var description: String {
        return "Currency: { symbol: \(symbol), value: \(value) }"
    }
    
    init(dictionary: (key: String, value: Float)) {
        
        self.symbol = dictionary.key
        self.value = dictionary.value
    }
}
