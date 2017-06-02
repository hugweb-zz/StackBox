//
//  HorizontalRandomController.swift
//  PopStackView
//
//  Created by Hugues Blocher on 02/06/2017.
//  Copyright © 2017 Hugues Blocher. All rights reserved.
//

import UIKit
import StackBox

class HorizontalRandomController: UIViewController {
    
    let stack = StackBox()
    var views: [StackBoxView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stack.axis = .horizontal
        view.backgroundColor = UIColor.white
        view.addSubview(stack)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Pop", style: .plain, target: self, action: #selector(HorizontalRandomController.pop)),
                                                   UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil),
                                                   UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(HorizontalRandomController.remove))]
    }
    
    func generateLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.gray
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed efficitur augue nisi, ut placerat eros volutpat blandit. Morbi id tortor ac quam pretium egestas id eu nulla."
        return label
    }
    
    func pop() {
        let random = Int(arc4random_uniform(2))
        let multiplier: CGFloat = [0, 20, 40, 60, 80, 100][Int(arc4random_uniform(UInt32(6)))]
        let view = random == 0 ? StackBoxView(view: generateLabel(), alignment: .trailing) : StackBoxView(view: generateLabel(), offset: multiplier)
        views.append(view)
        stack.pop(views: [view])
    }
    
    func remove() {
        if let view = views.last {
            stack.delete(views: [view])
            views.removeLast()
        }
    }
}
