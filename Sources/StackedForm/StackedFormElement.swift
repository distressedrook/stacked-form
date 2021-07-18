//
//  StackedFormElementViewController.swift
//  StackedForm
//
//  Created by Avismara HL on 17/07/21.
//

import UIKit

@objc public protocol StackedFormElement {
    var collapsedView: UIView! { get set }
    var expandedView: UIView! { get set }
    
    var collapsedViewHeight: CGFloat { get set }
    var ctaButtonText: String? { get set }
    
    var valid: Bool { get set }
    var delegate: StackedFormElementDelegate? { get set }
    
    func prepareToCollapse()
    func prepareToExpand()
}

@objc public protocol StackedFormElementDelegate {
    func dataDidBecomeInvalid(in stackedFormElement: StackedFormElement)
    func dataDidBecomeValid(in stackedFormElement: StackedFormElement)
    func didFinishInput(in stackedFormElement: StackedFormElement)
}

extension StackedFormElement {
    public var overlapSpace: CGFloat {
        return StackedFormView.OVERLAP_HEIGHT
    }
}
