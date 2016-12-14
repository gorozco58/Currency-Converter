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

    static func setup(barChartView: BarChartView) {
    
        barChartView.chartDescription?.enabled = false
        barChartView.drawGridBackgroundEnabled = false
        barChartView.dragEnabled = true
        barChartView.setScaleEnabled(true)
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.drawValueAboveBarEnabled = true
        barChartView.maxVisibleCount = 60
        barChartView.rightAxis.enabled = false
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1.0
        xAxis.labelCount = 4
        xAxis.valueFormatter = DefaultAxisValueFormatter()
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = " $"
        leftAxisFormatter.positiveSuffix = " $"
        
        let leftAxis = barChartView.leftAxis
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10)
        leftAxis.labelCount = 6
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
        legend.font = UIFont.helvetica(size: 11)
        legend.xEntrySpace = 4.0
        
        let marker = XYMarkerView(color: .gray,
                                  font: UIFont.systemFont(ofSize: 12),
                                  textColor: .white,
                                  insets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 20.0, right: 8.0),
                                  xAxisValueFormatter: barChartView.xAxis.valueFormatter!)
        
        marker.chartView = barChartView
        marker.minimumSize = CGSize(width: 80.0, height: 40.0)
        barChartView.marker = marker
    }
}
