//
//  VerticalSpecificIndexController.swift
//  StackBox
//
//  Created by Hugues Blocher on 05/06/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import StackBox

class VerticalSpecificIndexController: UIViewController {
    
    let stack = StackBoxView()
    var views: [StackBoxItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(stack)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(VerticalSpecificIndexController.add)),
                                                   UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil),
                                                   UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(VerticalSpecificIndexController.reset))]
        
        reset()
    }
    
    func reset() {
        
        stack.delete(views: views)
        views = []
        
        var items = [generateView(),
                     generateView(),
                     generateView(),
                     generateView()]
        
        items.shuffle().forEach { views.append($0) }
        stack.pop(views: items)
    }
    
    func add() {
        let index = Int(arc4random_uniform(UInt32(views.count)))
        let box = generateView()
        views.insert(box, at: index)
        stack.pop(views: [box], atIndex: index)
    }
    
    private func generateView() -> StackBoxItem {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        view.backgroundColor = UIColor.random
        return StackBoxItem(view: view)
    }
}
