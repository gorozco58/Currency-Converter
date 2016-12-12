//
//  CurrencyNetworking.swift
//  Currency Converter
//
//  Created by Giovanny Orozco on 12/12/16.
//  Copyright © 2016 Giovanny Orozco. All rights reserved.
//

import Foundation
import Alamofire

protocol CurrencyNetworkingType {
  
    static func getCurrencies(base: Currency, completion: () -> Void)
}

struct CurrencyNetworking : CurrencyNetworkingType {
    
    static func getCurrencies(base: Currency, completion: () -> Void) {
    
        Alamofire.request(AlamofireRouter.getCurrencies(base: base)).response { response in
            
            print(response)
        }
    }
}
