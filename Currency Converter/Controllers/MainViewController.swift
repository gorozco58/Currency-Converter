//
//  MainViewController.swift
//  Currency Converter
//
//  Created by Giovanny Orozco on 12/12/16.
//  Copyright © 2016 Giovanny Orozco. All rights reserved.
//

import UIKit
import SVProgressHUD
import MarqueeLabel
import Charts

class MainViewController: UIViewController {

    //MARK: @IBOutlet
    @IBOutlet weak var baseTextField: UITextField!
    @IBOutlet weak var rateLabel: MarqueeLabel!
    @IBOutlet weak var barChartView: BarChartView!
    
    //MARK: Private vars
    private(set) var base: Currency
    private(set) var currencies: [Currency] = []
    
    //MARK: Life cycle
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
        baseTextField.text = String(base.value)
        ChartsFactory.setup(barChartView: barChartView, delegate: self)
        loadCurrencies()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    //MARK: - Utils
    func loadCurrencies() {
    
        SVProgressHUD.show()
        
        CurrencyNetworking.getCurrencies(base) { [weak self] result in
            
            SVProgressHUD.dismiss()
            
            switch result {
            case .success(let currencies):
                
                self?.currencies = currencies
                self?.reloadData()
                
            case .failure(let error):
                
                self?.show(error: error)
            }
        }
    }
    
    func reloadData() {
        
        rateLabel.text = currencies.reduce("") { $0 + "- \($1.symbol): \($1.accumulatedValue) -" }
        
        let values = currencies.enumerated().map { BarChartDataEntry(x: Double($0), y: Double($1.inversed)) }
        ChartsFactory.set(values: values, to: barChartView)
        barChartView.animate(yAxisDuration: 2)
    }
    
    func show(error: Error) {
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
}

//MARK: - UITextFieldDelegate
extension MainViewController : UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        return Float(newString) != nil || newString.isEmpty
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if let quantity = Float(textField.text!) {
            base.quantity = quantity
            currencies.forEach { $0.quantity = quantity }
            reloadData()
            
            textField.resignFirstResponder()
        }
        
        return true
    }
}

//MARK: - XYMarkerViewDelegate
extension MainViewController : XYMarkerViewDelegate {

    func textForMarkerView(_ view: XYMarkerView, didSelectAtIndex index: Int) -> String {
        
        let currency = currencies[index]
        return "\(base.symbol): \(currency.accumulatedValue)"
    }
}

//MARK: - ChartViewDelegate
extension MainViewController : ChartViewDelegate {

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("chartValueSelected")
    }
}

//MARK: - CurrencyFormatterDelegate
extension MainViewController : CurrencyFormatterDelegate {

    func currencyFormater(_ formatter: CurrencyFormatter, stringAtIndex index: Int) -> String {
        
        let currency = currencies[index]
        return currency.symbol
    }
}

