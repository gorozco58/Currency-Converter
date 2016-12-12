//
//  LocalizableEnum.swift
//  Betiply
//
//  Created by Juan Alberto Uribe Otero on 9/14/15.
//  Copyright © 2015 Betiply. All rights reserved.
//

import Foundation

enum LocalizableString: String {
    
    //Common
    case title = "Currency Converter"
    
    var string: String {
        return NSLocalizedString(rawValue, comment: "")
    }
    
    func localizedStringWithArguments(arguments: [CVarArg]) -> String {
        
        return String(format: string, arguments: arguments)
    }
}
