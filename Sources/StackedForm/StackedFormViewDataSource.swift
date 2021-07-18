//
//  StackedFormViewDataSource.swift
//  StackedForm
//
//  Created by Avismara HL on 17/07/21.
//

import UIKit

/**
 Methods for asking the number of stack view elements and the stack view element at a particular index.
 */
@objc public protocol StackedFormViewDataSource: AnyObject {
    /**
     Asks the data source for the number of elements in the stacked form view.
     - Parameter stackedFormView: The stacked form view informing the delegate of this impending event.
     - Returns: The number of elements in the stack view.
     */
    func numberOfElements(in stackedFormView: StackedFormView) -> Int
    
    /**
     Asks the data source for a stacked form element to insert in a particular location of the stacked form view.
     - Parameter stackedFormView: The stacked form view informing the delegate of this impending event.
     - Parameter index: The position at which this stacked form element needs to be shown
     - Returns: The number of elements in the stack view.
     */
    func stackedFormView(_ stackedFormView: StackedFormView, stackedFormElementAt index: Int) -> StackedFormElement
}
