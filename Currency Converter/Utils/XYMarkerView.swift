//
//  XYMarkerView.swift
//  Currency Converter
//
//  Created by Giovanny Orozco on 12/13/16.
//  Copyright © 2016 Giovanny Orozco. All rights reserved.
//

import Foundation
import Charts

protocol XYMarkerViewDelegate : class {

    func textForMarkerView(_ view: XYMarkerView, didSelectAtIndex index: Int) -> String
}

class XYMarkerView: BalloonMarker {
    
    fileprivate var yFormatter = NumberFormatter()
    
    var xAxisValueFormatter: IAxisValueFormatter?
    weak var delegate: XYMarkerViewDelegate?
    
    init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets, xAxisValueFormatter: IAxisValueFormatter) {
        
        super.init(color: color, font: font, textColor: textColor, insets: insets)
        self.xAxisValueFormatter = xAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        
        if let delegate = delegate {
            setLabel(delegate.textForMarkerView(self, didSelectAtIndex: Int(entry.x)))
        }
    }
}
