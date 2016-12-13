//
//  ChartsFactory.swift
//  Currency Converter
//
//  Created by Giovanny Orozco on 12/13/16.
//  Copyright © 2016 Giovanny Orozco. All rights reserved.
//

import Foundation
import Charts

struct ChartsFactory {

    static func setup(barLineChartView: BarLineChartViewBase) {
    
        barLineChartView.chartDescription?.enabled = false
        barLineChartView.drawGridBackgroundEnabled = false
        barLineChartView.dragEnabled = true
        barLineChartView.setScaleEnabled(true)
        barLineChartView.pinchZoomEnabled = false
        
        let xAxis = barLineChartView.xAxis
        xAxis.labelPosition = .bottom
        
        barLineChartView.rightAxis.enabled = false
    }
}
