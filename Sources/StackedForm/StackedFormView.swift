//
//  StackedFormView.swift
//  StackedForm
//
//  Created by Avismara HL on 17/07/21.
//
#if !os(macOS)
import UIKit

/**
 Create an instance of this view to avail the stacked form.
 
 **Important:**
 - Care needs to be taken that there is enough space to display all the form elements. Should the size of this view be smaller than its contents, there is no scrolling support as yet and your view *will* break.
 - It is also safe to say that this library may not work best in landscape mode, where the height becomes too small to embed any meaningful form.
 - This library remains untested on an iPad, but there's no reason to believe that it would not work on an it.
 */
open class StackedFormView: UIView {
    private static let MIN_ELEMENTS_COUNT = 2
    private static let MAX_ELEMENTS_COUNT = 4
    private static let ANIMATION_TIME = 0.3
    static let OVERLAP_HEIGHT: CGFloat = 50
    
    /**
     The object that acts as the delegate of the stacked form view.
     */
    @IBOutlet public weak var delegate: StackedFormViewDelegate?
    
    /**
     The object that acts as the data source of the stacked form view.
     */
    @IBOutlet public weak var dataSource: StackedFormViewDataSource!
    
    private var numberOfItems = 2
    private var elementInfos = [ElementInfo]()
    private var currentExpandedIndex = 0
    private var ctaButton = UIButton()
}

//MARK: Public Methods
extension StackedFormView {
    /**
     Returns the stacked form element at the asked index.
     - Parameter index: The index locating the stacked form element in the view.
     - Returns: Stacked form element at the given index. `nil` if the index is invalid.
     */
    open func stackedFormElement(at index: Int) -> StackedFormElement? {
        if index < 0 || index >= self.numberOfItems {
            return nil
        }
        return self.elementInfos[index].stackedFormElement
    }
    
    /**
     Resets the current state of stacked form view and queries the data source to show the view. Stacked form view will **not** behave as expected unless this method is called.
     
     **Important**: Call this method only *after* setting the `dataSource` property. Will result in a crash otherwise.
     */
    open func setup() {
        guard dataSource != nil else {
            fatalError("Ensure that the data source has been set. Terminating.")
        }
        self.reset()
        self.addCtaButton()
        self.queryNumberOfItems()
        self.queryElements()
        self.expand(at: 0, animated: false)
        self.setCtaButtonState(for: 0)
        self.clipsToBounds = true
    }
}

//MARK: Private Setup Methods
extension StackedFormView {
    private func reset() {
        for elementInfo in self.elementInfos {
            elementInfo.viewArea.removeFromSuperview()
        }
        self.elementInfos.removeAll()
        self.numberOfItems = 0
        self.currentExpandedIndex = 0
        self.ctaButton.removeFromSuperview()
        self.ctaButton = UIButton()
    }
    
    private func addCtaButton() {
        self.addSubview(self.ctaButton)
        self.ctaButton.addTarget(self, action: #selector(StackedFormView.didTapNextButton(sender:)), for: .touchUpInside)
        let buttonHeight = self.delegate?.heightForCtaButton(in: self) ?? StackFormViewAutomaticCtaButtonHeight
        let heightConstraint = ctaButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        NSLayoutConstraint.activate([
            ctaButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            ctaButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            ctaButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            heightConstraint
        ])
        self.ctaButton.translatesAutoresizingMaskIntoConstraints = false
        self.ctaButton.backgroundColor = UIColor.green
        self.layoutIfNeeded()
    }
    
    private func queryNumberOfItems() {
        numberOfItems = dataSource.numberOfElements(in: self)
        if numberOfItems < StackedFormView.MIN_ELEMENTS_COUNT  {
            fatalError("The number of steps in the form cannot be lesser than \(StackedFormView.MIN_ELEMENTS_COUNT)")
        } else if numberOfItems > StackedFormView.MAX_ELEMENTS_COUNT {
            fatalError("The number of steps in the form cannot be greater than \(StackedFormView.MAX_ELEMENTS_COUNT)")
        }
    }
    
    private func queryElements() {
        self.numberOfItems = self.dataSource.numberOfElements(in: self)
        for i in 0 ..< numberOfItems {
            self.addElement(at: i)
        }
    }
}

//MARK: Internal Selectors
extension StackedFormView {
    @objc func handleTap(sender: UIGestureRecognizer) {
        guard let view = sender.view else {
            fatalError("This can never be nil")
        }
        let previousExpandedIndex = self.currentExpandedIndex
        self.expand(at: view.tag, animated: true) { [weak self] in
            self?.collapse(at: previousExpandedIndex, animated: false)
        }
        self.setCtaButtonState(for: view.tag)
    }
    
    @objc func didTapNextButton(sender: UIButton) {
        if self.currentExpandedIndex == self.numberOfItems - 1 {
            self.delegate?.stackedFormView(self, didCompleteFormWith: self.elementInfos.map{$0.stackedFormElement})
            return
        }
        let previousExpandedIndex = self.currentExpandedIndex
        self.expand(at: previousExpandedIndex + 1, animated: false) { [weak self] in
            self?.collapse(at: previousExpandedIndex, animated: true)
        }
        self.setCtaButtonState(for: previousExpandedIndex + 1)
    }
}

//MARK: Private Helpers
extension StackedFormView {
    private func setCtaButtonState(for index: Int) {
        let formElement = self.elementInfos[index].stackedFormElement
        if let text = formElement.ctaButtonText {
            UIView.animate(withDuration: StackedFormView.ANIMATION_TIME) {
                self.ctaButton.alpha = 1.0
            }
            self.ctaButton.setTitle(text, for: .normal)
        } else {
            UIView.animate(withDuration: StackedFormView.ANIMATION_TIME) {
                self.ctaButton.alpha = 0.0
            }
        }
        
        if formElement.valid {
            self.ctaButton.isEnabled = true
            self.delegate?.stackedFormView(self, styleButtonForValidStateWith: self.ctaButton)
        } else {
            self.ctaButton.isEnabled = false
            self.delegate?.stackedFormView(self, styleButtonForInvalidStateWith: self.ctaButton)
        }
    }
    
    private func addElement(at index: Int) {
        let stackedFormElement = dataSource.stackedFormView(self, stackedFormElementAt: index)
        stackedFormElement.collapsedView.translatesAutoresizingMaskIntoConstraints = false
        stackedFormElement.expandedView.translatesAutoresizingMaskIntoConstraints = false
        if stackedFormElement.delegate == nil {
            stackedFormElement.delegate = self
        }
        
        self.styleCtaButton(valid: stackedFormElement.valid)
        
        let height = self.delegate?.stackedFormView(self, collapsedHeightForElementAt: index) ?? StackFormViewAutomaticElementHeight
        let view = self.view(for: index)
        
        let heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
        
        let topAnchor: NSLayoutYAxisAnchor
        var overlapConstant: CGFloat = 0
        if index == 0 {
            topAnchor = self.topAnchor
        } else {
            topAnchor = self.elementInfos[index - 1].viewArea.bottomAnchor
            overlapConstant = StackedFormView.OVERLAP_HEIGHT
        }
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: -overlapConstant),
            view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            heightConstraint
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(StackedFormView.handleTap(sender:)))
        view.addGestureRecognizer(gestureRecogniser)
        
        let elementInfo = ElementInfo(stackedFormElement: stackedFormElement, viewArea: view, heightConstraint: heightConstraint, gestureRecogniser: gestureRecogniser)
        self.elementInfos.append(elementInfo)
        self.bringSubviewToFront(ctaButton)
    }
    
    private func view(for index: Int) -> UIView {
        let view = UIView()
        view.tag = index
        view.layer.cornerRadius = StackedFormView.OVERLAP_HEIGHT / 2
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 1.0
        self.addSubview(view)
        return view
    }
    
    private func styleCtaButton(valid: Bool) {
        if valid {
            self.delegate?.stackedFormView(self, styleButtonForValidStateWith: self.ctaButton)
        } else {
            self.delegate?.stackedFormView(self, styleButtonForInvalidStateWith: self.ctaButton)
        }
    }
    
    private func expand(at index: Int, animated: Bool, completed: (() -> ())? = nil) {
        self.delegate?.stackedFormView?(self, willElementExpandAt: index)
        let elementInfo = self.elementInfos[index]
        self.prepareElementToExpand(elementInfo, at: index)
        if animated {
            self.animateExpand(for: elementInfo, at: index, completed: completed)
        } else {
            self.suddenlyExpand(for: elementInfo, at: index, completed: completed)
        }
    }
    
    private func collapse(at index: Int, animated: Bool, completed: (() -> ())? = nil) {
        self.delegate?.stackedFormView?(self, willElementCollapseAt: index)
        let elementInfo = self.elementInfos[index]
        self.prepareElementToCollapse(elementInfo, at: index)
        if animated {
            self.animateCollapse(for: elementInfo, at: index, completed: completed)
        } else {
            self.suddenlyCollapse(for: elementInfo, at: index, completed: completed)
        }
    }
    
    private func stickSidesOfView(view: UIView, to anotherView: UIView) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: anotherView.topAnchor, constant: 0),
            view.leftAnchor.constraint(equalTo: anotherView.leftAnchor, constant: 0),
            view.rightAnchor.constraint(equalTo: anotherView.rightAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: anotherView.bottomAnchor, constant: 0)
        ])
    }
    
    private func prepareElementToCollapse(_ elementInfo: ElementInfo, at index: Int) {
        elementInfo.stackedFormElement.prepareToCollapse()
        elementInfo.viewArea.addGestureRecognizer(elementInfo.gestureRecogniser)
        elementInfo.viewArea.addSubview(elementInfo.stackedFormElement.collapsedView)
        elementInfo.viewArea.backgroundColor = elementInfo.stackedFormElement.expandedView.backgroundColor
        self.stickSidesOfView(view: elementInfo.viewArea, to: elementInfo.stackedFormElement.collapsedView)
        elementInfo.stackedFormElement.collapsedView.alpha = 0
        let height = self.delegate?.stackedFormView(self, collapsedHeightForElementAt: index) ?? StackFormViewAutomaticElementHeight
        elementInfo.heightConstraint.constant = height + StackedFormView.OVERLAP_HEIGHT
    }
    
    private func prepareElementToExpand(_ elementInfo: ElementInfo, at index: Int) {
        elementInfo.stackedFormElement.prepareToExpand()
        elementInfo.viewArea.removeGestureRecognizer(elementInfo.gestureRecogniser)
        elementInfo.viewArea.addSubview(elementInfo.stackedFormElement.expandedView)
        elementInfo.viewArea.backgroundColor = elementInfo.stackedFormElement.collapsedView.backgroundColor
        self.stickSidesOfView(view: elementInfo.viewArea, to: elementInfo.stackedFormElement.expandedView)
        elementInfo.stackedFormElement.expandedView.alpha = 0
        elementInfo.heightConstraint.constant = self.frame.size.height
    }
    
    private func animateCollapse(for elementInfo: ElementInfo, at index: Int, completed: (() -> ())?) {
        UIView.animate(withDuration: StackedFormView.ANIMATION_TIME / 2) {
            elementInfo.stackedFormElement.expandedView.alpha = 0
        } completion: { status in
            UIView.animate(withDuration: StackedFormView.ANIMATION_TIME / 2) {
                elementInfo.stackedFormElement.collapsedView.alpha = 1
            }
            elementInfo.stackedFormElement.expandedView.removeFromSuperview()
        }
        UIView.animate(withDuration: StackedFormView.ANIMATION_TIME) {
            elementInfo.viewArea.backgroundColor = elementInfo.stackedFormElement.collapsedView.backgroundColor
            self.layoutIfNeeded()
        } completion: { _ in
            self.delegate?.stackedFormView?(self, didElementCollapseAt: index)
            completed?()
        }
    }
    
    private func animateExpand(for elementInfo: ElementInfo, at index: Int, completed: (() -> ())?) {
        UIView.animate(withDuration: StackedFormView.ANIMATION_TIME / 2) {
            elementInfo.stackedFormElement.collapsedView.alpha = 0
        } completion: { status in
            UIView.animate(withDuration: StackedFormView.ANIMATION_TIME / 2) {
                elementInfo.stackedFormElement.expandedView.alpha = 1
                self.currentExpandedIndex = index
            }
            elementInfo.stackedFormElement.collapsedView.removeFromSuperview()
        }
        
        UIView.animate(withDuration: StackedFormView.ANIMATION_TIME) {
            elementInfo.viewArea.backgroundColor = elementInfo.stackedFormElement.expandedView.backgroundColor
            self.layoutIfNeeded()
        } completion: { _ in
            completed?()
            self.delegate?.stackedFormView?(self, didElementExpandAt: index)
        }
    }
    
    private func suddenlyCollapse(for elementInfo: ElementInfo, at index: Int, completed: (() -> ())?) {
        elementInfo.stackedFormElement.expandedView.removeFromSuperview()
        elementInfo.stackedFormElement.collapsedView.alpha = 1.0
        elementInfo.viewArea.backgroundColor = elementInfo.stackedFormElement.collapsedView.backgroundColor
        self.delegate?.stackedFormView?(self, didElementCollapseAt: index)
        completed?()
    }
    
    private func suddenlyExpand(for elementInfo: ElementInfo, at index: Int, completed: (() -> ())?) {
        elementInfo.stackedFormElement.collapsedView.removeFromSuperview()
        elementInfo.stackedFormElement.expandedView.alpha = 1.0
        self.currentExpandedIndex = index
        elementInfo.viewArea.backgroundColor = elementInfo.stackedFormElement.expandedView.backgroundColor
        self.delegate?.stackedFormView?(self, didElementExpandAt: index)
        completed?()
    }
}

//MARK: ElementInfo Class Declaration
extension StackedFormView {
    private class ElementInfo {
        let stackedFormElement: StackedFormElement
        let heightConstraint: NSLayoutConstraint
        let viewArea: UIView
        let gestureRecogniser: UIGestureRecognizer
        
        init(stackedFormElement: StackedFormElement, viewArea: UIView, heightConstraint: NSLayoutConstraint, gestureRecogniser: UIGestureRecognizer) {
            self.stackedFormElement = stackedFormElement
            self.heightConstraint = heightConstraint
            self.viewArea = viewArea
            self.gestureRecogniser = gestureRecogniser
        }
    }
}

//MARK: StackedFormElementDelegate Implementations
extension StackedFormView: StackedFormElementDelegate {
    public func didFinishInput(in stackedFormElement: StackedFormElement) {
        self.didTapNextButton(sender: self.ctaButton)
    }
    
    public func dataDidBecomeInvalid(in stackedFormElement: StackedFormElement) {
        self.ctaButton.isEnabled = false
        self.delegate?.stackedFormView(self, styleButtonForInvalidStateWith: self.ctaButton)
    }
    
    public func dataDidBecomeValid(in stackedFormElement: StackedFormElement) {
        self.ctaButton.isEnabled = true
        self.delegate?.stackedFormView(self, styleButtonForValidStateWith: self.ctaButton)
    }
}
#endif
