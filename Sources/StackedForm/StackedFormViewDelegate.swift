//
//  StackedFormViewDelegate.swift
//  StackedForm
//
//  Created by Avismara HL on 17/07/21.
//

import UIKit

@objc public protocol StackedFormViewDelegate: AnyObject {
    @objc optional func stackedFormView(_ stackedFormView: StackedFormView, willElementExpandAt index: Int)
    @objc optional func stackedFormView(_ stackedFormView: StackedFormView, willElementCollapseAt index: Int)
    
    @objc optional func stackedFormView(_ stackedFormView: StackedFormView, didElementExpandAt index: Int)
    @objc optional func stackedFormView(_ stackedFormView: StackedFormView, didElementCollapseAt index: Int)
    
    func stackedFormView(_ stackedFormView: StackedFormView, styleButtonForInvalidStateWith button: UIButton)
    func stackedFormView(_ stackedFormView: StackedFormView, styleButtonForValidStateWith button: UIButton)
    func stackedFormView(_ stackedFormView: StackedFormView, didCompleteFormWith formElements: [StackedFormElement])
}
