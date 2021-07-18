//
//  StackedFormElementViewController.swift
//  StackedForm
//
//  Created by Avismara HL on 17/07/21.
//

import UIKit

/**
 Protocol that represents each collapsed/expanded state of the stacked form view. Create an element by implementing this protocol for supplying it to the stack form view.
 
 **Important:** When you are designing `expandedView`, make sure you are laying out constraints in a top-bottom fashion and that none of the views' positions are dependant on the `bottomAnchor` of  `expandedView`. Laying out this way might cause the view to go out of bounds.
 */
@objc public protocol StackedFormElement {
    /**
     View that represents the collapsed state of the element.
     */
    var collapsedView: UIView! { get set }
    
    /**
     View that represents the expanded state of the element.
     */
    var expandedView: UIView! { get set }
    
    /**
     Height of the collapsed state of the element, excluding the overlap space.
     */
    var collapsedViewHeight: CGFloat { get set }
    
    /**
     The text of the of call to action button that corresponds to this stacked form element. A `nil` value will cause the call to action button disappear with animation. Conversly, if the call to action button does not exist for the previous element, the call to action button will appear with animation when set.
     */
    var ctaButtonText: String? { get set }
    
    /**
     A boolean that indicates whether the data of the current form is in a valid state. If the value of the property changes, inform the delegate of the change so it could disable/enable the call to action button accordingly. 
     */
    var valid: Bool { get set }
    
    /**
     The object that acts as the delegate of the stacked form view. It is not necesssary to set this property. Stacked form view will automatically act as the delegate and perform relevant actions when not set.
     */
    var delegate: StackedFormElementDelegate? { get set }
    
    /**
     Stacked form view will call this method **before** the expanded stacked form element collapses. This is the best place to copy the data from the expanded view to the collapsed view.
     */
    func prepareToCollapse()
    
    /**
     Stacked form view will call this method **before** the expanded stacked form element expands.
     */
    func prepareToExpand()
}

/**
 Methods for informing the data validity and completion of input inside a stacked form element.
 */
@objc public protocol StackedFormElementDelegate {
    /**
     Informs the delegate that the data in this form element has become invalid.
     
     When the delegate of stacked form element is not set, this method will automatically disable the call to action button.
     - Parameter stackedFormElement: The stacked form element informing the delegate of this impending event.
     */
    func dataDidBecomeInvalid(in stackedFormElement: StackedFormElement)
    
    /**
     Informs the delegate that the data in this form element has become valid.
     
     When the delegate of stacked form element is not set, this method will automatically enable the call to action button.
     - Parameter stackedFormElement: The stacked form element informing the delegate of this impending event.
     */
    func dataDidBecomeValid(in stackedFormElement: StackedFormElement)
    
    /**
     Informs the delegate that the user is done filling the current form.
     
     When the delegate of stacked form element is not set, calling this method on the delegate of stacked form element will automaticaly collapse the current element and move on to the next. Use this method when you want to trigger collapse without having the user tapping the call to action button.
     - Parameter stackedFormElement: The stacked form element informing the delegate of this impending event.
     */
    func didFinishInput(in stackedFormElement: StackedFormElement)
}

extension StackedFormElement {
    /**
     Spacing from the bottom of stacked form element that is unsafe for your sub-views of collapsed view to be placed.
     
     **Important:**  When the element is collapsed, the next stacked form element will sit on this area. If you have placed any views in this area, it will get hidden behind the next element. Make sure your views are always placed above this.
     */
    public var overlapSpace: CGFloat {
        return StackedFormView.OVERLAP_HEIGHT
    }
}
