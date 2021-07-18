//
//  StackedFormViewDataSource.swift
//  StackedForm
//
//  Created by Avismara HL on 17/07/21.
//

import UIKit

@objc public protocol StackedFormViewDataSource: AnyObject {
    func numberOfItems(in stackedFormView: StackedFormView) -> Int
    func stackedFormView(_ stackedFormView: StackedFormView, stackedFormElementAt index: Int) -> StackedFormElement
    func stackedFormView(_ stackedFormView: StackedFormView, collapsedHeightForElementAt index: Int) -> CGFloat
    func heightForCtaButton(in stackedFormView: StackedFormView) -> CGFloat
}
