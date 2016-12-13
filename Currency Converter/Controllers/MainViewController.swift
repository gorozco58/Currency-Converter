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
        setupChartView()

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
    
        var rates = ""
        currencies.forEach { currency in
            rates += "- \(currency.symbol): \(currency.accumulatedValue) -"
        }
        
        rateLabel.text = rates
        updateChartData()
    }
    
    fileprivate func setupChartView() {
    
        ChartsFactory.setup(barLineChartView: barChartView)
        
        barChartView.delegate = self
        barChartView.drawBarShadowEnabled = false
        barChartView.drawValueAboveBarEnabled = true
        barChartView.maxVisibleCount = 60
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1.0 // only intervals of 1 day
        xAxis.labelCount = 7
        xAxis.valueFormatter = DefaultAxisValueFormatter()
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = " $"
        leftAxisFormatter.positiveSuffix = " $"
        
        let leftAxis = barChartView.leftAxis
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0.0
        
        let legend = barChartView.legend
        legend.horizontalAlignment = .left
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.form = .square
        legend.formSize = 9.0
        legend.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        legend.xEntrySpace = 4.0
        
        let marker = XYMarkerView(color: ColorHelper.greyMarker,
                                  font: UIFont.systemFont(ofSize: 12),
                                  textColor: .white,
                                  insets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 20.0, right: 8.0),
                                  xAxisValueFormatter: barChartView.xAxis.valueFormatter!)
        
        marker.chartView = barChartView
        marker.minimumSize = CGSize(width: 80.0, height: 40.0)
        barChartView.marker = marker
    }
    
    fileprivate func updateChartData() {
    
        let count = 13
        let range = 50
        let start = 1
        var yVals: [BarChartDataEntry] = []
        
        for i in start..<start + count + 1 {
        
            let mult = range+1
            let val = arc4random_uniform(UInt32(mult))
            yVals.append(BarChartDataEntry(x: Double(i), y: Double(val)))
        }
        
        if let data = barChartView.data, data.dataSetCount > 0 {
            
            if let set1 = data.dataSets[0] as? BarChartDataSet {
                set1.values = yVals
                data.notifyDataChanged()
                barChartView.notifyDataSetChanged()
            }
        } else {
            
            let set1 = BarChartDataSet(values: yVals, label: "The year 2017")
            set1.setColors(ChartColorTemplates.material(), alpha: 1)
            
            let data = BarChartData(dataSets: [set1])
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
            data.barWidth = 0.9
            
            barChartView.data = data
        }
    }
}

//MARK: - ChartViewDelegate
extension MainViewController : ChartViewDelegate {

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("chartValueSelected")
    }
}

