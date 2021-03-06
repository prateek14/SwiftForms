//
//  FormSegmentedControlCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 21/08/14.
//  Copyright (c) 2016 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

public class FormSegmentedControlCell: FormBaseCell {
    
    // MARK: Cell views
    
    public let titleLabel = UILabel()
    public let segmentedControl = UISegmentedControl()
    
    // MARK: Properties
    
    private var customConstraints: [AnyObject] = []
    
    // MARK: FormBaseCell
    
    public override func configure() {
        super.configure()
        
        selectionStyle = .None
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.setContentCompressionResistancePriority(500, forAxis: .Horizontal)
        segmentedControl.setContentCompressionResistancePriority(500, forAxis: .Horizontal)
        
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(segmentedControl)
        
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: segmentedControl, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        segmentedControl.addTarget(self, action: #selector(FormSegmentedControlCell.valueChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    public override func update() {
        super.update()
        
        titleLabel.text = rowDescriptor?.title
        updateSegmentedControl()
        
        guard let value = rowDescriptor?.value else { return }
        guard let options = rowDescriptor?.configuration.selection.options where !options.isEmpty else { return }
        
        var idx = 0
        for optionValue in options {
            if optionValue === value {
                segmentedControl.selectedSegmentIndex = idx
                break
            }
            idx += 1
        }
    }
    
    public override func constraintsViews() -> [String : UIView] {
        return ["titleLabel" : titleLabel, "segmentedControl" : segmentedControl]
    }
    
    public override func defaultVisualConstraints() -> [String] {
        if let text = titleLabel.text where text.characters.count > 0 {
            return ["H:|-16-[titleLabel]-16-[segmentedControl]-16-|"]
        } else {
            return ["H:|-16-[segmentedControl]-16-|"]
        }
    }
    
    // MARK: Actions
    
    internal func valueChanged(sender: UISegmentedControl) {
        guard let options = rowDescriptor?.configuration.selection.options where !options.isEmpty else { return }
        let value = options[sender.selectedSegmentIndex]
        rowDescriptor?.value = value
    }
    
    // MARK: Private
    
    private func updateSegmentedControl() {
        segmentedControl.removeAllSegments()
        
        guard let options = rowDescriptor?.configuration.selection.options where !options.isEmpty else { return }
        
        var idx = 0
        for value in options {
            let title = rowDescriptor?.configuration.selection.optionTitleClosure?(value)
            segmentedControl.insertSegmentWithTitle(title, atIndex: idx, animated: false)
            idx += 1
        }
    }
}
