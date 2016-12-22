//
//  CurrencyNetworking.swift
//  Currency Converter
//
//  Created by Giovanny Orozco on 12/12/16.
//  Copyright © 2016 Giovanny Orozco. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

protocol CurrencyNetworkingType {
  
    static func getCurrencies(_ base: Currency) -> Observable<Result<[Currency]>>
}

struct CurrencyNetworking : CurrencyNetworkingType {
    
    static func getCurrencies(_ base: Currency) -> Observable<Result<[Currency]>> {
        
        return requestJSON(.get, AlamofireUrl.getCurrencies(base: base))
            .map { (response, json) -> Result<[Currency]> in
                guard let jsonData = json as? [String : AnyObject],
                    let possibleCurrencies = jsonData["rates"] as? [String : Float] else {
                        return .failure(CommonError.parsingError)
                }
                
                let currencies = possibleCurrencies.map(Currency.init)
                return .success(currencies)
            }
            .catchError { _ in
                let result = Result<[Currency]>.failure(CommonError.networkError)
                return Observable.just(result)
        }
    }
}

