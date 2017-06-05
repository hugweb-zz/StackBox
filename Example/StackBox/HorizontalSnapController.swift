//
//  HorizontalSnapController.swift
//  PopStackView
//
//  Created by Hugues Blocher on 02/06/2017.
//  Copyright © 2017 Hugues Blocher. All rights reserved.
//

import UIKit
import SnapKit
import StackBox

class HorizontalSnapController: UIViewController {
    
    let stack = StackBox()
    var views: [StackBoxView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stack.axis = .horizontal
        view.backgroundColor = UIColor.white
        view.addSubview(stack)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(HorizontalSnapController.randomRemove)),
                                                   UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil),
                                                   UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(HorizontalSnapController.reset))]
        reset()
    }
    
    func reset() {
        
        stack.delete(views: views)
        views = []
        
        let header = UIView()
        header.backgroundColor = UIColor.random
        header.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width / 2)
            make.height.equalTo(40)
        }
        let footer = UIView()
        footer.backgroundColor = UIColor.random
        footer.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(100)
        }
        
        let topContent = UIView()
        topContent.backgroundColor = UIColor.random
        topContent.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width / 3)
            make.height.equalTo(150)
        }
        
        let bottomContent = UIView()
        bottomContent.backgroundColor = UIColor.random
        bottomContent.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width / 1.2)
            make.height.equalTo(50)
        }
        
        let extraContent = UIView()
        extraContent.backgroundColor = UIColor.random
        extraContent.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width / 4)
            make.height.equalTo(50)
        }
        
        var items = [StackBoxView(view: header, alignment: .leading),
                     StackBoxView(view: topContent),
                     StackBoxView(view: bottomContent, alignment: .trailing),
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
