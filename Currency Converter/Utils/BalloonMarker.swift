//
//  BalloonMarker.swift
//  Currency Converter
//
//  Created by Giovanny Orozco on 12/13/16.
//  Copyright © 2016 Giovanny Orozco. All rights reserved.
//

import Foundation
import Charts


class BalloonMarker: MarkerImage {
    
    var color: UIColor?
    var arrowSize = CGSize(width: 15, height: 11)
    var font: UIFont?
    var textColor: UIColor?
    var insets = UIEdgeInsets()
    var minimumSize = CGSize()
    
    fileprivate var labelns: NSString?
    fileprivate var labelSize = CGSize()
    fileprivate var paragraphStyle: NSMutableParagraphStyle?
    fileprivate var drawAttributes = [String : AnyObject]()
    
    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets) {
        
        super.init()
        
        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets
        
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        paragraphStyle?.alignment = .center
    }
    
    override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        
        let size = self.size
        var point = point
        point.x -= size.width / 2.0
        point.y -= size.height
        
        return super.offsetForDrawing(atPoint: point)
    }
    
    override func draw(context: CGContext, point: CGPoint) {
        
        if labelns == nil {
            return
        }
        
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height
        
        context.saveGState()
        
        if let color = color {
            
            context.setFillColor(color.cgColor)
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width / 2.0,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.fillPath()
        }
        
        rect.origin.y += self.insets.top
        rect.size.height -= self.insets.top + self.insets.bottom
        
        UIGraphicsPushContext(context)
        
        labelns?.draw(in: rect, withAttributes: drawAttributes)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        
        setLabel(String(entry.y))
    }
    
    func setLabel(_ label: String) {
        
        labelns = label as NSString
        
        drawAttributes.removeAll()
        drawAttributes[NSFontAttributeName] = self.font
        drawAttributes[NSParagraphStyleAttributeName] = paragraphStyle
        drawAttributes[NSForegroundColorAttributeName] = self.textColor
        
        labelSize = labelns?.size(attributes: drawAttributes) ?? CGSize.zero
        
        var size = CGSize()
        size.width = labelSize.width + self.insets.left + self.insets.right
        size.height = labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}
