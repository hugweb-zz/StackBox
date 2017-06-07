//
//  StackBox.swift
//  StackBox
//
//  Created by Hugues Blocher on 30/05/2017.
//  Copyright © 2017 Hugues Blocher. All rights reserved.
//

import UIKit

/*
 StackBoxView is a scrollable container where you can easily insert and remove subviews.
 StackBoxView is dynamic so you don't have to worry about the contentSize. Subcontent is
 manage by a UIStackView
 */

public class StackBoxView: UIScrollView {
    
    // MARK: Public var
    public var duration: Double = 0.3
    public var animated = true
    public var axis: UILayoutConstraintAxis = .vertical {
        didSet {
            self.stackView.axis = self.axis
            self.stackView.layout()
        }
    }
    
    // MARK: Private var
    private var boxes: [StackBoxContainer] = [] {
        didSet {
            let new = boxes
            let old = oldValue
            let values = old.count > new.count ? old.filter { element in return !new.contains(element) } : new.filter { element in return !old.contains(element) }
            update(boxes: values)
        }
    }
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.preservesSuperviewLayoutMargins = true
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0.0
        return stackView
    }()
    
    // MARK: Lifecycle
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public convenience init(axis: UILayoutConstraintAxis, animated: Bool) {
        self.init()
        self.axis = axis
        self.animated = animated
        initialize()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    // MARK: Initial constraints setup
    private func initialize() {
        
        translatesAutoresizingMaskIntoConstraints = false
        preservesSuperviewLayoutMargins = false
        layoutMargins = .zero
        backgroundColor = UIColor.clear
        
        addSubview(stackView)
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[stackView]-0-|",
            options: [],
            metrics: nil,
            views: ["stackView": stackView])
        )
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[stackView]-0-|",
            options: [],
            metrics: nil,
            views: ["stackView": stackView])
        )
        
        stackView.layoutMargins = stackView.layoutMargins
        addConstraint(topAnchor.constraint(equalTo: stackView.topAnchor))
        addConstraint(bottomAnchor.constraint(equalTo: stackView.bottomAnchor))
        addConstraint(leadingAnchor.constraint(equalTo: stackView.leadingAnchor))
        addConstraint(trailingAnchor.constraint(equalTo: stackView.trailingAnchor))
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        pinToSuperview()
    }
    
    // MARK: Superview constraints
    private func pinToSuperview() {
        guard let superview = superview else { return }
        
        superview.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[scrollView]-0-|",
            options: [],
            metrics: nil,
            views: ["scrollView": self])
        )
        superview.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[scrollView]-0-|",
            options: [],
            metrics: nil,
            views: ["scrollView": self])
        )
        
        self.layoutIfNeeded()
    }
    
    // MARK: Update StackView
    private func update(boxes: [StackBoxContainer]) {
        if boxes.count > 1 {
            var deletion: [StackBoxContainer] = []
            var insertion: [StackBoxContainer] = []
            boxes.forEach { (box) in contain(box: box) ? insertion.append(box) : deletion.append(box) }
            removeBox(boxes: deletion)
            addBox(boxes: insertion)
        } else {
            boxes.forEach { (box) in contain(box: box) ? addBox(boxes: [box], atIndex: self.boxes.index(of: box) ?? 0) : removeBox(boxes: [box]) }
        }
    }
    
    private func contain(box: StackBoxContainer) -> Bool {
        return self.boxes.contains(box)
    }
    
    // MARK: Private items management
    private func addBox(boxes: [StackBoxContainer], atIndex: Int = 0) {
        let values = boxes.map { $0.attachView(axis: axis) }
        values.forEach { (box) in
            box.isHidden = true
            stackView.insertArrangedSubview(box.attachView(axis: axis), at: atIndex == 0 ? stackView.arrangedSubviews.count : atIndex)
            UIView.animate(withDuration: duration) {
                box.isHidden = false
            }
        }
    }
    
    private func removeBox(boxes: [StackBoxContainer]) {
        //        UIView.animate(withDuration: duration, animations: {
        //            boxes.forEach { (box) in
        //                box.isHidden = true
        //            }
        //        }, completion: { (success) in
        //            boxes.forEach { (box) in
        //                self.stackView.removeArrangedSubview(box)
        //                box.removeFromSuperview()
        //            }
        //        })
        boxes.forEach { (box) in
            removeBox(box: box)
        }
    }
    
    private func removeBox(box: StackBoxContainer) {
        UIView.animate(withDuration: duration, animations: {
            box.isHidden = true
        }, completion: { (success) in
            self.stackView.removeArrangedSubview(box)
            box.removeFromSuperview()
        })
    }
    
    // MARK: Public stack management
    public func pop(views: [StackBoxItem], atIndex: Int = 0) {
        if views.count > 1 {
            boxes.insert(contentsOf: views.map { StackBoxContainer(view: $0) }, at: atIndex == 0 ? boxes.count : atIndex)
        } else {
            views.forEach { (view) in boxes.insert(StackBoxContainer(view: view), at: atIndex == 0 ? boxes.count : atIndex)}
        }
    }
    
    public func pop(view: StackBoxItem, atIndex: Int = 0) {
        boxes.insert(StackBoxContainer(view: view), at: atIndex == 0 ? boxes.count : atIndex)
    }
    
    public func deleteLast() {
        boxes.remove(at: boxes.count - 1)
    }
    
    public func delete(views: [StackBoxItem]) {
        views.forEach { (view) in if let index = boxes.index(where: { $0.view == view }) {
            boxes.remove(at: index)
            }
        }
    }
}

/*
 StackBoxItem is encapsulate into a StackBoxContainer
 Create your own StackBoxItem by setting his view and offset as you please
 */

public enum StackBoxItemAlignment {
    case leading
    case center
    case trailing
}

public struct StackBoxItem: Hashable {
    
    var item: UIView
    var offset: CGFloat = 0.0
    var alignment: StackBoxItemAlignment = .leading
    var clipsToBounds: Bool = true
    var backgroundColor: UIColor = UIColor.clear
    
    fileprivate var activeConstraints: [NSLayoutConstraint] = []
    
    public init(view: UIView,
                alignment: StackBoxItemAlignment = .leading,
                offset: CGFloat = 0.0,
                backgroundColor: UIColor = UIColor.clear,
                clipsToBounds: Bool = true) {
        self.item = view
        self.alignment = alignment
        self.offset = offset
        self.backgroundColor = backgroundColor
        self.clipsToBounds = clipsToBounds
    }
    
    public var hashValue: Int {
        return "\(item)\(offset)".hashValue
    }
    
    public static func ==(lhs: StackBoxItem, rhs: StackBoxItem) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

/*
 StackBoxContainer is the container object use by the StackBoxView to render stacks
 It contains the StackBoxItem create initialy by the user
 */

private class StackBoxContainer: UIView {
    
    var view: StackBoxItem
    private var activeConstraints: [NSLayoutConstraint] = []
    private var axis: UILayoutConstraintAxis = .vertical
    
    init(view: StackBoxItem) {
        self.view = view
        super.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func ==(lhs: StackBoxContainer, rhs: StackBoxContainer) -> Bool {
        return lhs.view.item.hashValue == rhs.view.item.hashValue
    }
    
    func attachView(axis: UILayoutConstraintAxis) -> StackBoxContainer {
        self.clipsToBounds = self.view.clipsToBounds
        self.axis = axis
        self.backgroundColor = self.view.backgroundColor
        addSubview(view.item)
        return self
    }
    
    private func setupConstraints() {
        boxConstraints()
        viewConstraints()
    }
    
    private func boxConstraints() {
        if let stackView = superview?.superview, stackView.frame.size.width > 0 {
            activeConstraints.append(widthAnchor.constraint(equalToConstant: stackView.frame.size.width))
        } else {
            activeConstraints.append(widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width))
        }
        if view.item.frame.size.height > 0 {
            activeConstraints.append(heightAnchor.constraint(equalToConstant: view.item.frame.size.height + view.offset))
        } else {
            if let heigthConstraint = view.item.hasConstraint(attribute: .height), heigthConstraint.constant > 0  {
                activeConstraints.append(heightAnchor.constraint(equalToConstant: heigthConstraint.constant + view.offset))
            } else {
                debugPrint("No height was set for \(view) !!!!! View may not be visible !!!!!")
            }
        }
        
        activeConstraints.forEach { (c) in
            c.priority = 999
            c.isActive = true
        }
    }
    
    private func viewConstraints() {
        if view.item.frame.size.width > 0 && view.item.frame.size.height > 0 {
            view.activeConstraints.append(view.item.widthAnchor.constraint(equalToConstant: view.item.frame.size.width))
            view.activeConstraints.append(view.item.heightAnchor.constraint(equalToConstant: view.item.frame.size.height + view.offset))
        } else {
            if let box = superview?.superview, view.item.hasConstraint(attribute: .width) == nil {
                view.activeConstraints.append(view.item.widthAnchor.constraint(equalToConstant: box.frame.size.width))
            }
        }
        switch axis {
        case .vertical:
            view.activeConstraints.append(view.item.topAnchor.constraint(equalTo: topAnchor, constant: view.offset))
            view.activeConstraints.append(view.item.bottomAnchor.constraint(equalTo: bottomAnchor))
            switch view.alignment {
            case .leading:
                view.activeConstraints.append(view.item.leadingAnchor.constraint(equalTo: leadingAnchor))
            case .center:
                view.activeConstraints.append(view.item.centerXAnchor.constraint(equalTo: centerXAnchor))
            case .trailing:
                view.activeConstraints.append(view.item.trailingAnchor.constraint(equalTo: trailingAnchor))
            }
        case .horizontal:
            view.activeConstraints.append(view.item.topAnchor.constraint(equalTo: topAnchor))
            view.activeConstraints.append(view.item.bottomAnchor.constraint(equalTo: bottomAnchor))
            switch view.alignment {
            case .leading:
                view.activeConstraints.append(view.item.leftAnchor.constraint(equalTo: leftAnchor, constant: view.offset))
            case .center:
                view.activeConstraints.append(view.item.centerXAnchor.constraint(equalTo: centerXAnchor, constant: view.offset))
            case .trailing:
                view.activeConstraints.append(view.item.rightAnchor.constraint(equalTo: rightAnchor, constant: view.offset))
            }
        }
        view.activeConstraints.forEach { (c) in
            c.priority = 999
            c.isActive = true
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview != nil {
            setupConstraints()
        }
    }
}

extension UIView {
    func hasConstraint(attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        var constraint: NSLayoutConstraint?
        constraints.forEach { (c) in if c.firstAttribute == attribute { constraint = c } }
        return constraint
    }
}

extension UIStackView {
    func layout() {
        UIView.animate(withDuration: 0.3) {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
}
