//
//  RandomController.swift
//  PopStackView
//
//  Created by Hugues Blocher on 30/05/2017.
//  Copyright © 2017 Hugues Blocher. All rights reserved.
//

import UIKit
import StackBox

class VerticalRandomController: UIViewController {
    
    let stack = StackBoxView()
    var views: [StackBoxItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(stack)

        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Pop", style: .plain, target: self, action: #selector(VerticalRandomController.pop)),
                                                   UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil),
                                                   UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(VerticalRandomController.remove))]
    }
    
    func generateLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.random
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed efficitur augue nisi, ut placerat eros volutpat blandit. Morbi id tortor ac quam pretium egestas id eu nulla."
        return label
    }
    
    func pop() {
        let random = Int(arc4random_uniform(2))
        let multiplier: CGFloat = [0, 20, 40, 60, 80, 100][Int(arc4random_uniform(UInt32(6)))]
        let view = random == 0 ? StackBoxItem(view: generateLabel(), alignment: .trailing) : StackBoxItem(view: generateLabel(), offset: multiplier)
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
