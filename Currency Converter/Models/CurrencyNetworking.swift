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
  
    static func getCurrencies(_ base: Currency, completion: @escaping (Result<[Currency]>) -> Void)
}

struct CurrencyNetworking : CurrencyNetworkingType {
    
    static func getCurrencies(_ base: Currency, completion: @escaping (Result<[Currency]>) -> Void) {
        
        Alamofire.request(AlamofireRouter.getCurrencies(base: base)).validate().responseJSON { response in
            
            switch response.result {
            case .success(let json):
                
                guard let jsonData = json as? [String : AnyObject],
                    let possibleCurrencies = jsonData["rates"] as? [String : Float] else {
                    completion(.failure(CommonError.parsingError))
                    return
                }
                
                let currencies = possibleCurrencies.map(Currency.init)
                completion(.success(currencies))
                
            case .failure(_):
                completion(.failure(CommonError.networkError))
            }
        }
    }
}
