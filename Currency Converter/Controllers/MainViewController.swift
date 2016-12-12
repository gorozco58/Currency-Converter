//
//  MainViewController.swift
//  Currency Converter
//
//  Created by Giovanny Orozco on 12/12/16.
//  Copyright © 2016 Giovanny Orozco. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    fileprivate let base = Currency(dictionary: (key: "USD", value: 1))
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
        self.title = LocalizableString.title.string
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        CurrencyNetworking.getCurrencies(base) { result in
        
            switch result {
            case .success(let currencies):
                print(currencies)
            case .failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
