//
//  Currency.swift
//  Currency Converter
//
//  Created by Giovanny Orozco on 12/12/16.
//  Copyright © 2016 Giovanny Orozco. All rights reserved.
//

import Foundation

class Currency {
  
    let symbol: String
    let value: Float
    var quantity: Float = 1
    var accumulatedValue: Float {
        return value * quantity
    }
    var inversed: Float {
        return quantity / value
    }
    
    init(dictionary: (key: String, value: Float)) {
        
        self.symbol = dictionary.key
        self.value = dictionary.value
    }
}

extension Currency : CustomStringConvertible {

    var description: String {
        return "Currency: { symbol: \(symbol), value: \(value) }"
    }
}
