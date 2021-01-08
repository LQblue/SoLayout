//
//  Typealiases.swift
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

#if os(iOS) || os(tvOS)
//#if swift(>=4.2)
    public typealias LayoutRelation = NSLayoutConstraint.Relation
    public typealias LayoutAttribute = NSLayoutConstraint.Attribute
//#else
//    public  typealias LayoutRelation = NSLayoutRelation
//    public typealias LayoutAttribute = NSLayoutAttribute
//#endif
    public typealias LayoutPriority = UILayoutPriority
#else
    public typealias LayoutRelation = NSLayoutConstraint.Relation
    public typealias LayoutAttribute = NSLayoutConstraint.Attribute
    public typealias LayoutPriority = NSLayoutConstraint.Priority
#endif

#if os(iOS) || os(tvOS)
    public typealias ConstraintInsets = UIEdgeInsets
#else
    public typealias ConstraintInsets = NSEdgeInsets
#endif

#if os(iOS) || os(tvOS)
    public typealias ConstraintView = UIView
#else
    public typealias ConstraintView = NSView
#endif

#if os(iOS) || os(tvOS)
    @available(iOS 9.0, *)
    public typealias ConstraintLayoutGuide = UILayoutGuide
#else
    @available(OSX 10.11, *)
    public typealias ConstraintLayoutGuide = NSLayoutGuide
#endif

public enum Axis {
    
    case vertical
    case horizontal
    case lastBaseline
    case fisrtBaseline
    
    var attribute: LayoutAttribute {
        switch self {
        case .vertical:
            return .centerY
        case .horizontal:
            return .centerX
        case .lastBaseline:
            return .lastBaseline
        case .fisrtBaseline:
            return .firstBaseline
        }
    }
    
    #if os(iOS)
    var marginAttribute: LayoutAttribute {
        switch self {
        case .vertical:
            return .centerYWithinMargins
        case .horizontal:
            return .centerXWithinMargins
        default:
            assert(false, "Not a valid Axis")
            return .centerYWithinMargins
        }
    }
    #endif
    
}

public enum Edge {
    
    case left
    case right
    case top
    case bottom
    case leading
    case trailing
    
    var attribute: LayoutAttribute {
        switch self {
        case .left:
            return .left
        case .right:
            return .right
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
    
    #if os(iOS)
    var marginAttribute: LayoutAttribute {
        switch self {
        case .left:
            return .leftMargin
        case .right:
            return .rightMargin
        case .top:
            return .topMargin
        case .bottom:
            return .bottomMargin
        case .leading:
            return .leadingMargin
        case .trailing:
            return .trailingMargin
        }
    }
    #endif
    
}

public enum Dimension {
    
    case width
    case height
    
    var attribute: LayoutAttribute {
        switch self {
        case .width:
            return .width
        case .height:
            return .height
        }
    }
    
}

public enum Alignment {
    
    case vertical
    case horizontal
    case lastBaseline
    case fisrtBaseline
    case left
    case right
    case top
    case bottom
    case leading
    case trailing
    
}
