//
//  SoLayout.swift
//  SoLayout
//
//  Created by liqi on 2020/12/30.
//

import Foundation
#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public struct SoWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

protocol SoCompatibleValue: AnyObject {}
protocol SoCompatibleClassValue: AnyObject {}
protocol SoCompatible {}

extension SoCompatible {
    var so: SoWrapper<Self> {
        get { return SoWrapper(self) }
        set { }
    }
}

extension SoCompatibleValue {
    var so: SoWrapper<Self> {
        get { return SoWrapper(self) }
        set { }
    }
}

extension SoCompatibleClassValue {
    static var so: SoWrapper<Self.Type> {
        get { return SoWrapper(self) }
        set { }
    }
}

extension ConstraintView: SoCompatibleValue {}
extension NSLayoutConstraint: SoCompatibleClassValue {}
extension NSLayoutConstraint: SoCompatibleValue {}
extension Array: SoCompatible {}
