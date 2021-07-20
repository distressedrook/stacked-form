//
//  StackedFormViewDelegate.swift
//  StackedForm
//
//  Created by Avismara HL on 17/07/21.
//

#if !os(macOS)
import UIKit

/**
 Methods for informing the expansion and collapse events, styling the call to action button for valid and invalid states and completion of the form. It also contains methods that asks the delegate for the layout information like collapsed stack element height and height of the call to action button.
 */
@objc public protocol StackedFormViewDelegate: AnyObject {
    /**
     Tells the delegate the element at the given `index` is about to expand.
     - Parameter stackedFormView: The stacked form view informing the delegate of this impending event.
     - Parameter index: The index at which the element is about to expand.
     */
    @objc optional func stackedFormView(_ stackedFormView: StackedFormView, willElementExpandAt index: Int)
    
    /**
     Tells the delegate the element at the given `index` is about to collapse.
     - Parameter stackedFormView: The stacked form view informing the delegate of this impending event.
     - Parameter index: The index at which the element is about to collapse.
     */
    @objc optional func stackedFormView(_ stackedFormView: StackedFormView, willElementCollapseAt index: Int)
    
    /**
     Tells the delegate the element at the given `index`has expanded.
     - Parameter stackedFormView: The stacked form view informing the delegate of this impending event.
     - Parameter index: The index at which the element has expanded.
     */
    @objc optional func stackedFormView(_ stackedFormView: StackedFormView, didElementExpandAt index: Int)
    
    /**
     Tells the delegate the element at the given `index`has collapsed.
     - Parameter stackedFormView: The stacked form view informing the delegate of this impending event.
     - Parameter index: The index at which the element has collapsed.
     */
    @objc optional func stackedFormView(_ stackedFormView: StackedFormView, didElementCollapseAt index: Int)
    
    /**
     Asks the delegate to style call to action button for the invalid state
     - Parameter stackedFormView: The stacked form view informing the delegate of this impending event.
     - Parameter button: The button that needs to be styled.
     */
    func stackedFormView(_ stackedFormView: StackedFormView, styleButtonForInvalidStateWith button: UIButton)
    
    /**
     Asks the delegate to style call to action button for the valid state.
     - Parameter stackedFormView: The stacked form view informing the delegate of this impending event.
     - Parameter button: The button that needs to be styled.
     */
    func stackedFormView(_ stackedFormView: StackedFormView, styleButtonForValidStateWith button: UIButton)
    
    /**
     Tells the delegate that the user completed filling the form.
     - Parameter stackedFormView: The stacked form view informing the delegate of this impending event.
     - Parameter formElements: List of stacked form elements that contains the latest data entered by the user
     */
    func stackedFormView(_ stackedFormView: StackedFormView, didCompleteFormWith formElements: [StackedFormElement])
    
    /**
     Asks the delegate for the height of the collapsed stacked form view element at a given index.
     - Parameter stackedFormView: The stacked form view informing the delegate of this impending event.
     - Parameter index: Index of the collapsed view that needs the height information.
     - Returns: Desired height of the collapsed stacked form element. Return `StackFormViewAutomaticElementHeight` for default height.
     */
    func stackedFormView(_ stackedFormView: StackedFormView, collapsedHeightForElementAt index: Int) -> CGFloat
    
    /**
     Tells the delegate to style call to action button for the valid state.
     - Parameter stackedFormView: The stacked form view informing the delegate of this impending event.
     - Returns: Desired height of the call to action button. Return `StackFormViewAutomaticCtaButtonHeight` for default height.
     */
    func heightForCtaButton(in stackedFormView: StackedFormView) -> CGFloat
}
#endif
