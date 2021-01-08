//
//  ViewController.swift
//  SoLayout
//
//  Created by liqi on 2020/11/30.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let blackV = UIView()
//        blackV.pinToSuperview(edge: .top, inset: 300)
        blackV.backgroundColor = .black
        view.addSubview(blackV)
//        blackV.centerInSuperview()
//        blackV.setSize(with: .init(width: 200, height: 200))
        
        let redV = UIView()
        redV.backgroundColor = .red
        view.addSubview(redV)
//        redV.centerInSuperview(margin: true)
//        redV.setSize(with: .init(width: 200, height: 200))
        
        let orangeV = UIView()
        orangeV.backgroundColor = .orange
        view.addSubview(orangeV)
//        orangeV.pinToSuperviewSafeArea(with: .top)
//        orangeV.pinToSuperviewSafeArea(with: .right, inset: 10)
//        orangeV.setSize(with: .init(width: 200, height: 200))
//        [blackV, redV, orangeV].align(to: .vertical)
//        blackV.setSize(with: .init(width: 100, height: 100))
//        [blackV, redV, orangeV].match(with: .width)
//        [redV, orangeV].setSize(in: .height, of: 50)
//        redV.pin(edge: .left, to: .right, of: blackV, offset: 10)
//        orangeV.pin(edge: .left, to: .right, of: redV, offset: 10)
//        blackV.pinToSuperview(edge: .left)
//        blackV.pinToSuperview(edge: .top, inset: 300)
//        blackV.pinToSuperview(edge: .top, inset: 300)
//        blackV.setSize(in: .height, of: 50)
//        redV.setSize(in: .height, of: 100)
//        orangeV.setSize(in: .height, of: 150)
//        [blackV, redV, orangeV].distribute(axis: .vertical, align: .horizontal, spacing: 50, insetSpacing: true, matchedSize: true)
        
        blackV.so.pinToSuperView(edges: .left, .top, inset: 100)
        blackV.so.setSize(with: .init(width: 50, height: 100))
        
        redV.so.pinToSuperView(edges: .right, .top, inset: 100)
        redV.so.matchSize(with: .height, to: .height, of: blackV, diff: 50, multipilier: 0.5)
        redV.so.matchSize(with: .width, to: .width, of: blackV)
        
        
//        redV.so.setSize(with: .init(width: 50, height: 100))
//        NSLayoutConstraint.so.setPriority(with: .defaultHigh) {
//            redV.setContentCompressionResistancePriority(for: .horizontal)
//        }
//        NSLayoutConstraint.so.setPriority(with: <#T##LayoutPriority#>, for: <#T##() -> ()#>)
    }


}

