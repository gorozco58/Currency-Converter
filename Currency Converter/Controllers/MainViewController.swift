//
//  MainViewController.swift
//  Currency Converter
//
//  Created by Giovanny Orozco on 12/12/16.
//  Copyright © 2016 Giovanny Orozco. All rights reserved.
//

import UIKit
import SVProgressHUD

class MainViewController: UIViewController {

    //MARK: - @IBOutlet
    @IBOutlet fileprivate var rateLabels: [UILabel]!
    
    //MARK: - Private vars
    fileprivate var base: Currency
    fileprivate var currencies: [Currency] = []
    
    //MARK: - Life cycle
    init(base: Currency) {
        
        self.base = base
        super.init(nibName: nil, bundle: nil)
        self.title = LocalizableString.title.string
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        CurrencyNetworking.getCurrencies(base) { [weak self] result in
        
            switch result {
            case .success(let currencies):
                
                self?.currencies = currencies
                self?.reloadData()
                
            case .failure(let error):
                
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

//MARK: - UITextFieldDelegate
extension MainViewController : UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        return Float(newString) != nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if let quantity = Float(textField.text!) {
            base.quantity = quantity
            currencies.forEach { $0.quantity = quantity }
            reloadData()
        }
        
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Private
extension MainViewController {

    fileprivate func reloadData() {
    
        currencies.enumerated().forEach { (index, currency) in
            self.rateLabels[index].text = "\(currency.symbol): \(currency.accumulatedValue) -- Inversed: \(currency.inversed)"
        }
    }
}

