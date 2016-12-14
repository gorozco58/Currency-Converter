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

    //MARK: - @IBOutlet
    @IBOutlet fileprivate weak var rateLabel: MarqueeLabel!
    @IBOutlet fileprivate weak var barChartView: BarChartView!
    
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
        ChartsFactory.setup(barChartView: barChartView, delegate: self)

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
            
            textField.resignFirstResponder()
            return true
        }
        
        return false
    }
}

//MARK: - Private
extension MainViewController {

    fileprivate func reloadData() {
    
        var rates = ""
        currencies.forEach { currency in
            rates += "- \(currency.symbol): \(currency.accumulatedValue) -"
        }
        
        rateLabel.text = rates
        updateChartData()
    }
    
    fileprivate func updateChartData() {
    
        var values: [BarChartDataEntry] = []
        
        currencies.enumerated().forEach { (index, currency) in
            values.append(BarChartDataEntry(x: Double(index), y: Double(currency.inversed)))
        }
        
        if let data = barChartView.data, data.dataSetCount > 0 {
            
            if let set1 = data.dataSets[0] as? BarChartDataSet {
                set1.values = values
                data.notifyDataChanged()
                barChartView.notifyDataSetChanged()
            }
        } else {
            
            let set1 = BarChartDataSet(values: values, label: LocalizableString.currencies.string)
            set1.setColors(ChartColorTemplates.material(), alpha: 1)
            
            let data = BarChartData(dataSets: [set1])
            data.setValueFont(UIFont.helvetica(size: 10))
            data.barWidth = 0.9
            
            barChartView.data = data
        }
    }
}

//MARK: - XYMarkerViewDelegate
extension MainViewController : XYMarkerViewDelegate {

    func textForMarkerView(_ view: XYMarkerView, didSelectAtIndex index: Int) -> String {
        
        let currency = currencies[index]
        return "\(base.symbol): \(currency.value)"
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

