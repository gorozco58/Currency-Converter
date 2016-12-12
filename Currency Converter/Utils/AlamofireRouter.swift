//
//  AlamofireRouter.swift
//  Currency Converter
//
//  Created by Giovanny Orozco on 12/12/16.
//  Copyright © 2016 Giovanny Orozco. All rights reserved.
//

import Foundation
import Alamofire

enum AlamofireRouter : URLRequestConvertible {

    static let baseURLString = "http://api.fixer.io/"
    
    case getCurrencies(base: Currency)
    
    var method: HTTPMethod {
        switch self {
        case .getCurrencies:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getCurrencies:
            return "/latest"
        }
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        
        let url = try AlamofireRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .getCurrencies(let base):
            
            let parameters: Parameters = ["base" : base.symbol, "symbols" : "GBP,EUR,JPY,BRL"]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
