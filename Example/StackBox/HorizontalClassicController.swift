//
//  HorizontalClassicController.swift
//  PopStackView
//
//  Created by Hugues Blocher on 02/06/2017.
//  Copyright © 2017 Hugues Blocher. All rights reserved.
//

import UIKit
import StackBox

class HorizontalClassicController: UIViewController {
    
    let stack = StackBox()
    var views: [StackBoxView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stack.axis = .horizontal
        view.backgroundColor = UIColor.white
        view.addSubview(stack)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(HorizontalClassicController.randomRemove)),
                                                   UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil),
                                                   UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(HorizontalClassicController.reset))]
        
        reset()
    }
    
    func reset() {
        
        stack.delete(views: views)
        views = []
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        header.backgroundColor = UIColor.blue
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        footer.backgroundColor = UIColor.green
        let topContent = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
        topContent.backgroundColor = UIColor.orange
        let bottomContent = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 600))
        bottomContent.backgroundColor = UIColor.cyan
        
        var items = [StackBoxView(view: header),
                     StackBoxView(view: topContent),
                     StackBoxView(view: bottomContent),
                     StackBoxView(view: footer)]
        
        items.shuffle().forEach { views.append($0) }
        stack.pop(views: items)
    }
    
    func randomRemove() {
        let index = Int(arc4random_uniform(UInt32(views.count)))
        if views.count > 0 && index >= 0 {
            let view = views[index]
            stack.delete(views: [view])
            views.remove(at: index)
        }
    }
}
