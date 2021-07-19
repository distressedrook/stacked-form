# Stacked Form

Easily create highly customisable stacked forms on iOS that behave like this: 

<img src="https://s6.gifyu.com/images/Simulator-Screen-Recording---iPhone-12-mini---2021-07-19-at-00.43.47.gif" width="25%" height="25%"/>

This README contains documentation only. Usage guide and example projects will be added soon. [Inspiration.](https://dribbble.com/shots/5721735-InVision-Studio-Spaced-App)

# Table of Contents
- [Stacked Form](#stacked-form)
- [StackedFormView](#stackedformview)
  * [Inheritance](#inheritance)
  * [Properties](#properties)
    + [`delegate`](#-delegate-)
    + [`dataSource`](#-datasource-)
  * [Methods](#methods)
    + [`stackedFormElement(at:)`](#-stackedformelement-at---)
      - [Parameters](#parameters)
      - [Returns](#returns)
    + [`setup()`](#-setup---)
- [StackedFormViewDataSource](#stackedformviewdatasource)
  * [Inheritance](#inheritance-1)
  * [Requirements](#requirements)
    + [numberOfElements(in:​)](#numberofelements-in---)
      - [Parameters](#parameters-1)
      - [Returns](#returns-1)
    + [stackedFormView(\_:​stackedFormElementAt:​)](#stackedformview-----stackedformelementat---)
      - [Parameters](#parameters-2)
      - [Returns](#returns-2)
- [StackedFormViewDelegate](#stackedformviewdelegate)
  * [Inheritance](#inheritance-2)
  * [Requirements](#requirements-1)
    + [stackedFormView(\_:​styleButtonForInvalidStateWith:​)](#stackedformview-----stylebuttonforinvalidstatewith---)
      - [Parameters](#parameters-3)
    + [stackedFormView(\_:​styleButtonForValidStateWith:​)](#stackedformview-----stylebuttonforvalidstatewith---)
      - [Parameters](#parameters-4)
    + [stackedFormView(\_:​didCompleteFormWith:​)](#stackedformview-----didcompleteformwith---)
      - [Parameters](#parameters-5)
    + [stackedFormView(\_:​collapsedHeightForElementAt:​)](#stackedformview-----collapsedheightforelementat---)
      - [Parameters](#parameters-6)
      - [Returns](#returns-3)
    + [heightForCtaButton(in:​)](#heightforctabutton-in---)
      - [Parameters](#parameters-7)
      - [Returns](#returns-4)
  * [Optional Requirements](#optional-requirements)
    + [stackedFormView(\_:​willElementExpandAt:​)](#stackedformview-----willelementexpandat---)
      - [Parameters](#parameters-8)
    + [stackedFormView(\_:​willElementCollapseAt:​)](#stackedformview-----willelementcollapseat---)
      - [Parameters](#parameters-9)
    + [stackedFormView(\_:​didElementExpandAt:​)](#stackedformview-----didelementexpandat---)
      - [Parameters](#parameters-10)
    + [stackedFormView(\_:​didElementCollapseAt:​)](#stackedformview-----didelementcollapseat---)
      - [Parameters](#parameters-11)
- [StackedFormElement](#stackedformelement)
  * [Default Implementations](#default-implementations)
    + [`overlapSpace`](#-overlapspace-)
  * [Requirements](#requirements-2)
    + [collapsedView](#collapsedview)
    + [expandedView](#expandedview)
    + [collapsedViewHeight](#collapsedviewheight)
    + [ctaButtonText](#ctabuttontext)
    + [valid](#valid)
    + [delegate](#delegate)
    + [prepareToCollapse()](#preparetocollapse--)
    + [prepareToExpand()](#preparetoexpand--)
- [StackedFormElementDelegate](#stackedformelementdelegate)
  * [Requirements](#requirements-3)
    + [dataDidBecomeInvalid(in:​)](#datadidbecomeinvalid-in---)
      - [Parameters](#parameters-12)
    + [dataDidBecomeValid(in:​)](#datadidbecomevalid-in---)
      - [Parameters](#parameters-13)
    + [didFinishInput(in:​)](#didfinishinput-in---)
      - [Parameters](#parameters-14)

# StackedFormView

Create an instance of this view to avail the stacked form.

``` swift
open class StackedFormView: UIView 
```

**Important:**

  - Care needs to be taken that there is enough space to display all the form elements. Should the size of this view be smaller than its contents, there is no scrolling support as yet and your view *will* break.

  - It is also safe to say that this library may not work best in landscape mode, where the height becomes too small to embed any meaningful form.

  - This library remains untested on an iPad, but there's no reason to believe that it would not work it.

## Inheritance

[`StackedFormElementDelegate`](/StackedFormElementDelegate), `UIView`

## Properties

### `delegate`

The object that acts as the delegate of the stacked form view.

``` swift
@IBOutlet public weak var delegate: StackedFormViewDelegate?
```

### `dataSource`

The object that acts as the data source of the stacked form view.

``` swift
@IBOutlet public weak var dataSource: StackedFormViewDataSource!
```

## Methods

### `stackedFormElement(at:)`

Returns the stacked form element at the asked index.

``` swift
open func stackedFormElement(at index: Int) -> StackedFormElement? 
```

#### Parameters

  - index: The index locating the stacked form element in the view.

#### Returns

Stacked form element at the given index. `nil` if the index is invalid.

### `setup()`

Resets the current state of stacked form view and queries the data source to show the view. Stacked form view will **not** behave as expected unless this method is called.

``` swift
open func setup() 
```

**Important**: Call this method only *after* setting the `dataSource` property. Will result in a crash otherwise.

### `didFinishInput(in:)`

``` swift
public func didFinishInput(in stackedFormElement: StackedFormElement) 
```

### `dataDidBecomeInvalid(in:)`

``` swift
public func dataDidBecomeInvalid(in stackedFormElement: StackedFormElement) 
```

### `dataDidBecomeValid(in:)`

``` swift
public func dataDidBecomeValid(in stackedFormElement: StackedFormElement) 
```
# StackedFormViewDataSource

Methods for asking the number of stack view elements and the stack view element at a particular index.

``` swift
@objc public protocol StackedFormViewDataSource: AnyObject 
```

## Inheritance

`AnyObject`

## Requirements

### numberOfElements(in:​)

Asks the data source for the number of elements in the stacked form view.

``` swift
func numberOfElements(in stackedFormView: StackedFormView) -> Int
```

#### Parameters

  - stackedFormView: The stacked form view informing the delegate of this impending event.

#### Returns

The number of elements in the stack view.

### stackedFormView(\_:​stackedFormElementAt:​)

Asks the data source for a stacked form element to insert in a particular location of the stacked form view.

``` swift
func stackedFormView(_ stackedFormView: StackedFormView, stackedFormElementAt index: Int) -> StackedFormElement
```

#### Parameters

  - stackedFormView: The stacked form view informing the delegate of this impending event.
  - index: The position at which this stacked form element needs to be shown

#### Returns

The stacked form element that needs to be insert at the position

# StackedFormViewDelegate

Methods for informing the expansion and collapse events, styling the call to action button for valid and invalid states and completion of the form. It also contains methods that asks the delegate for the layout information like collapsed stack element height and height of the call to action button.

``` swift
@objc public protocol StackedFormViewDelegate: AnyObject 
```

## Inheritance

`AnyObject`

## Requirements

### stackedFormView(\_:​styleButtonForInvalidStateWith:​)

Asks the delegate to style call to action button for the invalid state

``` swift
func stackedFormView(_ stackedFormView: StackedFormView, styleButtonForInvalidStateWith button: UIButton)
```

#### Parameters

  - stackedFormView: The stacked form view informing the delegate of this impending event.
  - button: The button that needs to be styled.

### stackedFormView(\_:​styleButtonForValidStateWith:​)

Asks the delegate to style call to action button for the valid state.

``` swift
func stackedFormView(_ stackedFormView: StackedFormView, styleButtonForValidStateWith button: UIButton)
```

#### Parameters

  - stackedFormView: The stacked form view informing the delegate of this impending event.
  - button: The button that needs to be styled.

### stackedFormView(\_:​didCompleteFormWith:​)

Tells the delegate that the user completed filling the form.

``` swift
func stackedFormView(_ stackedFormView: StackedFormView, didCompleteFormWith formElements: [StackedFormElement])
```

#### Parameters

  - stackedFormView: The stacked form view informing the delegate of this impending event.
  - formElements: List of stacked form elements that contains the latest data entered by the user

### stackedFormView(\_:​collapsedHeightForElementAt:​)

Asks the delegate for the height of the collapsed stacked form view element at a given index.

``` swift
func stackedFormView(_ stackedFormView: StackedFormView, collapsedHeightForElementAt index: Int) -> CGFloat
```

#### Parameters

  - stackedFormView: The stacked form view informing the delegate of this impending event.
  - index: Index of the collapsed view that needs the height information.

#### Returns

Desired height of the collapsed stacked form element. Return `StackFormViewAutomaticElementHeight` for default height.

### heightForCtaButton(in:​)

Tells the delegate to style call to action button for the valid state.

``` swift
func heightForCtaButton(in stackedFormView: StackedFormView) -> CGFloat
```

#### Parameters

  - stackedFormView: The stacked form view informing the delegate of this impending event.

#### Returns

Desired height of the call to action button. Return `StackFormViewAutomaticCtaButtonHeight` for default height.

## Optional Requirements

### stackedFormView(\_:​willElementExpandAt:​)

Tells the delegate the element at the given `index` is about to expand.

``` swift
@objc optional func stackedFormView(_ stackedFormView: StackedFormView, willElementExpandAt index: Int)
```

#### Parameters

  - stackedFormView: The stacked form view informing the delegate of this impending event.
  - index: The index at which the element is about to expand.

### stackedFormView(\_:​willElementCollapseAt:​)

Tells the delegate the element at the given `index` is about to collapse.

``` swift
@objc optional func stackedFormView(_ stackedFormView: StackedFormView, willElementCollapseAt index: Int)
```

#### Parameters

  - stackedFormView: The stacked form view informing the delegate of this impending event.
  - index: The index at which the element is about to collapse.

### stackedFormView(\_:​didElementExpandAt:​)

Tells the delegate the element at the given `index`has expanded.

``` swift
@objc optional func stackedFormView(_ stackedFormView: StackedFormView, didElementExpandAt index: Int)
```

#### Parameters

  - stackedFormView: The stacked form view informing the delegate of this impending event.
  - index: The index at which the element has expanded.

### stackedFormView(\_:​didElementCollapseAt:​)

Tells the delegate the element at the given `index`has collapsed.

``` swift
@objc optional func stackedFormView(_ stackedFormView: StackedFormView, didElementCollapseAt index: Int)
```

#### Parameters

  - stackedFormView: The stacked form view informing the delegate of this impending event.
  - index: The index at which the element has collapsed.



# StackedFormElement

Protocol that represents each collapsed/expanded state of the stacked form view. Create an element by implementing this protocol for supplying it to the stack form view.

``` swift
@objc public protocol StackedFormElement 
```

**Important:** When you are designing `expandedView`, make sure you are laying out constraints in a top-bottom fashion and that none of the views' positions are dependant on the `bottomAnchor` of  `expandedView`. Laying out this way might cause the view to go out of bounds.

## Default Implementations

### `overlapSpace`

Spacing from the bottom of stacked form element that is unsafe for your sub-views of collapsed view to be placed.

``` swift
public var overlapSpace: CGFloat 
```

**Important:**  When the element is collapsed, the next stacked form element will sit on this area. If you have placed any views in this area, it will get hidden behind the next element. Make sure your views are always placed above this.

## Requirements

### collapsedView

View that represents the collapsed state of the element.

``` swift
var collapsedView: UIView! 
```

### expandedView

View that represents the expanded state of the element.

``` swift
var expandedView: UIView! 
```

### collapsedViewHeight

Height of the collapsed state of the element, excluding the overlap space.

``` swift
var collapsedViewHeight: CGFloat 
```

### ctaButtonText

The text of the of call to action button that corresponds to this stacked form element. A `nil` value will cause the call to action button disappear with animation. Conversly, if the call to action button does not exist for the previous element, the call to action button will appear with animation when set.

``` swift
var ctaButtonText: String? 
```

### valid

A boolean that indicates whether the data of the current form is in a valid state. If the value of the property changes, inform the delegate of the change so it could disable/enable the call to action button accordingly.

``` swift
var valid: Bool 
```

### delegate

The object that acts as the delegate of the stacked form view. It is not necesssary to set this property. Stacked form view will automatically act as the delegate and perform relevant actions when not set.

``` swift
var delegate: StackedFormElementDelegate? 
```

### prepareToCollapse()

Stacked form view will call this method **before** the expanded stacked form element collapses. This is the best place to copy the data from the expanded view to the collapsed view.

``` swift
func prepareToCollapse()
```

### prepareToExpand()

Stacked form view will call this method **before** the expanded stacked form element expands.

``` swift
func prepareToExpand()
```

# StackedFormElementDelegate

Methods for informing the data validity and completion of input inside a stacked form element.

``` swift
@objc public protocol StackedFormElementDelegate 
```

## Requirements

### dataDidBecomeInvalid(in:​)

Informs the delegate that the data in this form element has become invalid.

``` swift
func dataDidBecomeInvalid(in stackedFormElement: StackedFormElement)
```

When the delegate of stacked form element is not set, this method will automatically disable the call to action button.

#### Parameters

  - stackedFormElement: The stacked form element informing the delegate of this impending event.

### dataDidBecomeValid(in:​)

Informs the delegate that the data in this form element has become valid.

``` swift
func dataDidBecomeValid(in stackedFormElement: StackedFormElement)
```

When the delegate of stacked form element is not set, this method will automatically enable the call to action button.

#### Parameters

  - stackedFormElement: The stacked form element informing the delegate of this impending event.

### didFinishInput(in:​)

Informs the delegate that the user is done filling the current form.

``` swift
func didFinishInput(in stackedFormElement: StackedFormElement)
```

When the delegate of stacked form element is not set, calling this method on the delegate of stacked form element will automaticaly collapse the current element and move on to the next. Use this method when you want to trigger collapse without having the user tapping the call to action button.

#### Parameters

  - stackedFormElement: The stacked form element informing the delegate of this impending event.


