//
//  ProfileController.swift
//  StackBox
//
//  Created by Hugues Blocher on 02/06/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import StackBox
import SnapKit

class ProfileController: UIViewController {
    
    let stack = StackBox()
    var views: [StackBoxView] = []
    var options: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(stack)
        stack.pop(views: [header(), content(), footer()])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animate()
        }
    }
    
    private func header() -> StackBoxView {
        let header = UIView()
        header.backgroundColor = UIColor(hex: "00C9FF")
        header.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(180)
        }
        
        let avatar = UIImageView()
        header.addSubview(avatar)
        avatar.image = UIImage(named: "avatar")!
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = 50
        avatar.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.centerX.equalTo(header.snp.centerX)
            make.centerY.equalTo(header.snp.centerY).offset(-15)
        }
        
        let name = UILabel()
        header.addSubview(name)
        name.text = "Anonymous"
        name.textAlignment = .center
        name.font = UIFont(name: "Avenir-Medium", size: 17)
        name.textColor = UIColor.white
        name.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(30)
            make.centerX.equalTo(header.snp.centerX)
            make.top.equalTo(avatar.snp.bottom).offset(10)
        }
        
        return StackBoxView(view: header)
    }
    
    private func content() -> StackBoxView {
        let contentWidth = UIScreen.main.bounds.width - 100
        let content = UIStackView()
        content.axis = .vertical
        content.alignment = .center
        content.distribution = .equalSpacing
        content.spacing = 5
        content.snp.makeConstraints { (make) in
            make.width.equalTo(contentWidth)
        }
        
        let options = ["Account", "Friends", "Push notifications", "Password", "Data and Storage", "Help", "Tell a friend"]
        options.forEach { (o) in
            let option = UIButton()
            option.isHidden = true
            option.setTitle(o, for: .normal)
            option.titleLabel?.textAlignment = .center
            option.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 14)
            option.setTitleColor(UIColor.white, for: .normal)
            option.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
            option.backgroundColor = UIColor(hex: "80CFA9")
            option.layer.masksToBounds = true
            option.layer.cornerRadius = 20
            option.snp.makeConstraints { (make) in
                make.width.equalTo(contentWidth)
                make.height.equalTo(40)
            }
            content.addArrangedSubview(option)
            self.options.append(option)
        }
        
        return StackBoxView(view: content, alignment: .center, offset: 20)
    }
    
    private func footer() -> StackBoxView {

        let copyrights = UILabel()
        copyrights.text = "Copyright © 2017 by Anonymous.\nYour Rights Reserved 👍\n\n\n"
        copyrights.numberOfLines = 0
        copyrights.textAlignment = .center
        copyrights.font = UIFont(name: "Avenir-Medium", size: 12)
        copyrights.textColor = UIColor.darkGray
        copyrights.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        return StackBoxView(view: copyrights, offset: 30)
    }
    
    private func animate() {
        var delay: Double = 0.0
        self.options.forEach { option in
            delay += 0.15
            UIView.animate(withDuration: 0.10,
                           delay: delay,
                           usingSpringWithDamping: 0.9,
                           initialSpringVelocity: 0.5,
                           options: .curveLinear,
                           animations: { () -> Void in
                            option.isHidden = !option.isHidden
            }, completion: nil)
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
