//
//  NSArray+SoLayout.swift
//  SoLayout
//
//  Created by liqi on 2021/1/4.
//

import Foundation
#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public extension SoWrapper where Base == Array<NSLayoutConstraint> {
    
    func installConstraints() {
        /// 1.  添加 Priority 和 Identifier
        for con in base {
            con.setPriority()
            con.setIdentifier()
        }
        /// 2. 是否要激活约束
        if NSLayoutConstraint.preventToActivateConstraints {
            NSLayoutConstraint.currentCreatedConstraintsAppend(constraints: base)
        } else {
            NSLayoutConstraint.activate(base)
        }
    }
    
    func removeConstraints() {
        NSLayoutConstraint.deactivate(base)
    }
    
}

public extension SoWrapper where Base == Array<ConstraintView> {
    
    /**
     数组中的 `view` 以 `top/bottom/left/right` 边界 进行对齐
     
     # Explain:
     
     1.  对齐方式以第一个`view`为参与，进行`top/bottom/left/right` 边界对齐
     2.  此方式只创建对齐方向的约束，其他约束需要自己添加
     
     - parameter edge: 对齐边界
     - returns: 创建的约束
     */
    @discardableResult
    func align(to edge: Edge) -> [NSLayoutConstraint] {
        base.checkMinimumNumber(with: 2, method: #function)
        var constraints = [NSLayoutConstraint]()
        var previous: ConstraintView? = nil
        for v in base {
            v.so.prepareLayout()
            if let p = previous {
                constraints.append(v.so.pin(edge: edge, to: edge, of: p))
            }
            previous = v
        }
        return constraints
    }
    
    /**
     数组中的 `view` 以 `vertical/horizontal/lastBaseline/fisrtBaseline` 轴心 进行对齐
     
     # Explain:
     
     1.  对齐方式以第一个`view`为参与，进行`vertical/horizontal/lastBaseline/fisrtBaseline` 轴心对齐
     2.  此方式只创建轴心对齐方向的约束，其他约束需要自己添加
     
     - parameter axis: 对齐轴心
     - returns: 创建的约束
     */
    @discardableResult
    func align(to axis: Axis) -> [NSLayoutConstraint] {
        base.checkMinimumNumber(with: 2, method: #function)
        var constraints = [NSLayoutConstraint]()
        var previous: ConstraintView? = nil
        for v in base {
            v.so.prepareLayout()
            if let p = previous {
                constraints.append(v.so.align(axis: axis, to: p))
            }
            previous = v
        }
        return constraints
    }
    
}

public extension SoWrapper where Base == Array<ConstraintView> {
    
    /**
     使数组中的 `view` 在 `宽度/高度` 相等
     
     - parameter dimension: 宽度 / 高度
     - returns: 创建的约束
     */
    @discardableResult
    func matchSize(in dimension: Dimension) -> [NSLayoutConstraint] {
        base.checkMinimumNumber(with: 2, method: #function)
        var constraints = [NSLayoutConstraint]()
        var previous: ConstraintView? = nil
        for v in base {
            v.so.prepareLayout()
            if let p = previous {
                constraints.append(v.so.matchSize(with: dimension, to: dimension, of: p))
            }
            previous = v
        }
        return constraints
    }
    
    /**
     批量设置数组中的 `view` 的 `宽度/高度`
     
     - parameter dimension: 宽度 / 高度
     - parameter of: `宽度/高度` 具体值
     - returns: 创建的约束
     */
    @discardableResult
    func setSize(in dimension: Dimension, of: CGFloat) -> [NSLayoutConstraint] {
        base.checkMinimumNumber(with: 2, method: #function)
        var constraints = [NSLayoutConstraint]()
        for v in base {
            v.so.prepareLayout()
            constraints.append(v.so.setSize(in: dimension, of: of))
        }
        return constraints
    }
    
    /**
     批量设置数组中的 `view` 的 `大小`
     
     - parameter size: 大小
     - returns: 创建的约束
     */
    @discardableResult
    func setSize(with size: CGSize) -> [NSLayoutConstraint] {
        base.checkMinimumNumber(with: 2, method: #function)
        var constraints = [NSLayoutConstraint]()
        for v in base {
            v.so.prepareLayout()
            constraints.append(contentsOf: v.so.setSize(with: size))
        }
        return constraints
    }
    
}

public extension SoWrapper where Base == Array<ConstraintView> {
    
    @discardableResult
    func distribute(axis: Axis,
                    align: Alignment,
                    spacing: CGFloat,
                    insetSpacing: Bool,
                    matchedSize: Bool) -> [NSLayoutConstraint] {
        base.checkMinimumNumber(with: 1, method: #function)
        var dimension: Dimension = .width
        var firstEdge: Edge = .leading
        var lastEdge: Edge = .trailing
        if axis == .vertical {
            dimension = .height
            firstEdge = .top
            lastEdge = .bottom
        }
        let leadingSpacing = insetSpacing ? spacing : 0.0
        let trailingSpacing = insetSpacing ? spacing : 0.0
        var constraints = [NSLayoutConstraint]()
        var previous: ConstraintView? = nil
        for v in base {
            v.so.prepareLayout()
            if let p = previous {
                constraints.append(v.so.pin(edge: firstEdge, to: lastEdge, of: p, offset: spacing))
                if matchedSize {
                    constraints.append(v.so.matchSize(with: dimension, to: dimension, of: p))
                }
                constraints.append(v.align(attribute: align, to: p, for: axis, method: #function))
            } else {
                constraints.append(v.so.pinToSuperview(edge: firstEdge, inset: leadingSpacing))
            }
            previous = v
        }
        if let last = previous {
            constraints.append(last.so.pinToSuperview(edge: lastEdge, inset: trailingSpacing))
        }
        return constraints;
    }
    
    @discardableResult
    func distribute(axis: Axis, align: Alignment, fixedSize: CGFloat, insetSpacing: Bool) -> [NSLayoutConstraint] {
        base.checkMinimumNumber(with: 1, method: #function)
        var fixedDimension: Dimension = .width
        var attribute: LayoutAttribute = .centerX
        if axis == .vertical {
            fixedDimension = .height
            attribute = .centerY
        }
        var constraints = [NSLayoutConstraint]()
        var previous: ConstraintView? = nil
        let count = CGFloat(base.count)
        let commonSuperview = base.checkCommonSuperview(method: #function)
        for (idx, v) in base.enumerated() {
            v.so.prepareLayout()
            constraints.append(v.so.setSize(in: fixedDimension, of: fixedSize))
            var multiplier: CGFloat = 0
            var constant: CGFloat = 0
            if insetSpacing {
                multiplier = (CGFloat(idx) * 2.0 + 2.0) / (count + 1)
                constant = (multiplier - 1.0) * fixedSize / 2.0
            } else {
                multiplier = (CGFloat(idx) * 2.0) / (count - 1)
                constant = (-multiplier + 1.0) * fixedSize / 2.0
            }
            let multiplierMin: CGFloat = 0.00001
            if abs(multiplier) < multiplierMin {
                multiplier = multiplierMin
            }
            let constraint = v.so.layout(attribute: attribute, to: attribute, of: commonSuperview, offset: constant, multipilier: multiplier, relation: .equal)
            constraints.append(constraint)
            if let p = previous {
                constraints.append(v.align(attribute: align, to: p, for: axis, method: #function))
            }
            previous = v
        }
        return constraints;
    }
    
}

private extension Array where Element: ConstraintView {
    
    /// 检测多个`View`是否存在共同的 `Superview`
    /// - Parameter method: 当前检测时调用的方法
    /// - Returns: 共同的 `Superview`
    @discardableResult
    func checkCommonSuperview(method: String) -> ConstraintView {
        var commonSuperview: ConstraintView?
        var previous: ConstraintView?
        for v in self {
            if previous != nil, let c = commonSuperview {
                commonSuperview = v.checkCommonSuperview(with: c, method: method)
            } else {
                commonSuperview = v.superview
            }
            previous = v
        }
        assert(commonSuperview != nil,
               """
               \n\n***************************\n
               提示:    多个View不存在共同的Superview;
               Method: \(method);
               Views:  \(self);
               \n***************************\n\n
               """)
        return commonSuperview!
    }
    
    /// 检测`View`的数量
    /// - Parameters:
    ///   - number: 最小数量
    ///   - method: 当前检测时调用的方法
    func checkMinimumNumber(with number: Int, method: String) {
        
        assert(count >= number,
               """
               \n\n***************************\n
               提示:    数组至少包含\(number)个View;
               Count:  \(count);
               Method: \(method);
               Views:  \(self);
               \n***************************\n\n
               """)
    }
    
}
