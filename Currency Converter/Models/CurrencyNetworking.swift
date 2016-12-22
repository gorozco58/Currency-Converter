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
        
        let observable = PublishSubject<Result<[Currency]>>()
        
        Alamofire.request(AlamofireRouter.getCurrencies(base: base)).validate().responseJSON { response in
            
            switch response.result {
            case .success(let json):
                
                guard let jsonData = json as? [String : AnyObject],
                    let possibleCurrencies = jsonData["rates"] as? [String : Float] else {
                        observable.onNext(.failure(CommonError.parsingError))
                    return
                }
                
                let currencies = possibleCurrencies.map(Currency.init)
                observable.onNext(.success(currencies))
                
            case .failure(_):
                observable.onNext(.failure(CommonError.networkError))
            }
        }
        
        return observable.asObservable()
    }
}

struct NopDisposable : Disposable {
    
    fileprivate static let noOp: Disposable = NopDisposable()
    
    fileprivate init() {
        
    }
    
    /// Does nothing.
    public func dispose() {
    }
}
