//
//  ConstraintView+SoLayout.swift
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

public extension SoWrapper where Base: ConstraintView {
    
    /**
     设置 ```translatesAutoresizingMaskIntoConstraints = false```
     
     # Explain:
     
     1.  `translatesAutoresizingMaskIntoConstraints` 为 `true ` 时，表示将`frame布局`自动转化为`约束布局`
     2.  转化的结果是为这个视图自动添加所有需要的约束，如果这时给视图添加自己创建的约束会引起约束冲突
     */
    func prepareLayout() {
        base.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

public extension SoWrapper where Base: ConstraintView {
    
    /**
     设置`view`的宽高
     
     - parameter size: 宽高的值
     - returns: 创建的约束
     */
    @discardableResult
    func setSize(with size: CGSize) -> [NSLayoutConstraint] {
        let w = setSize(in: .width, of: size.width)
        let h = setSize(in: .height, of: size.height)
        return [w, h]
    }
    
    /**
     设置`view`的宽或高
     
     - parameter dimension: 宽 / 高
     - parameter value: 值
     - returns: 创建的约束
     */
    @discardableResult
    func setSize(in dimension: Dimension,
                 of value: CGFloat,
                 relation: LayoutRelation = .equal) -> NSLayoutConstraint {
        return layout(attribute: dimension.attribute, to: .notAnAttribute, of: nil, offset: value, multipilier: 1.0, relation: relation)
    }
    
    /**
     设置`view`的宽或高  与 `otherView`的宽或高 `相等/成比例/大于或小于相关值`
     
     # Example:
     ```
        let a = UIView()
        let b = UIView()
        superview.addSubview(a)
        superview.addSubview(b)
        a.match(with: .width, to: .height, of: b, offset: 10)
        /// a 的宽 == b 的高 + 10
     ```
     
     - parameter dimension: 宽 / 高
     - parameter otherDimension: 相对于`otherview`的 宽 / 高
     - parameter view: `otherview`，相比较的`view`
     - parameter diff: 差值
     - parameter multipilier: 比例
     - parameter relation: `= ` /  `>=`  /  `<=` 关系
     - returns: 创建的约束
     */
    @discardableResult
    func matchSize(with dimension: Dimension,
                   to otherDimension: Dimension,
                   of view: ConstraintView,
                   diff: CGFloat = 0.0,
                   multipilier: CGFloat = 1.0,
                   relation: LayoutRelation = .equal) -> NSLayoutConstraint {
        return layout(attribute: dimension.attribute, to: otherDimension.attribute, of: view, offset: diff, multipilier: multipilier, relation: relation)
    }
    
}

public extension SoWrapper where Base: ConstraintView {
    
    func setContentCompressionResistancePriority(for axis: NSLayoutConstraint.Axis) {
        assert(NSLayoutConstraint.isSettingPriority,
               "\(#function) should only be called from within the action passed into the method SoPriority.setPriority(with:for:)")
        if NSLayoutConstraint.isSettingPriority {
            prepareLayout()
            base.setContentCompressionResistancePriority(NSLayoutConstraint.currentPriority, for: axis)
        }
    }
    
    func setContentHuggingPriority(for axis: NSLayoutConstraint.Axis) {
        assert(NSLayoutConstraint.isSettingPriority,
               "\(#function) should only be called from within the action passed into the method SoPriority.setPriority(with:for:)")
        if NSLayoutConstraint.isSettingPriority {
            prepareLayout()
            base.setContentHuggingPriority(NSLayoutConstraint.currentPriority, for: axis)
        }
    }
    
}

public extension SoWrapper where Base: ConstraintView {
    
    /**
     使`view`在`Superview`布局中 `居中`
     
     - parameter margin: 基于margin的布局方式，默认为`false`
     - parameter margin: 创建的约束
     */
    @discardableResult
    func centerInSuperview(margin: Bool = false) -> [NSLayoutConstraint] {
        let h = alignToSuperview(axis: .horizontal, margin: margin)
        let v = alignToSuperview(axis: .vertical, margin: margin)
        return [h, v]
    }
    
    @discardableResult
    func alignToSuperview(axis: Axis, margin: Bool = false) -> NSLayoutConstraint {
        let superview = base.checkSuperview(method: #function)
        if margin {
            return layout(attribute: axis.marginAttribute, to: axis.marginAttribute, of: superview)
        }
        return layout(attribute: axis.attribute, to: axis.attribute, of: superview)
    }
    
    @discardableResult
    func align(axis: Axis,
               to otherView: UIView,
               offset: CGFloat = 0,
               multipilier: CGFloat = 1.0) -> NSLayoutConstraint {
        return layout(attribute: axis.attribute, to: axis.attribute, of: otherView, offset: offset, multipilier: multipilier)
    }
    
}

public extension SoWrapper where Base: ConstraintView {
    
    /**
     使`view`相对于`otherView`的`边界`进行布局
     
     # Example:
     ```
        let a = UIView()
        let b = UIView()
        superview.addSubview(a)
        superview.addSubview(b)
        a.so.pin(edge: .top, to: .bottom, of: b, offset: 10)
        /// a 的上边界 == b 的下边界 + 10
     ```
     
     - parameter edge: 布局边界
     - parameter otherEdge: 相对于`otherView`的布局边界
     - parameter otherView: 相对布局的 `view`
     - parameter offset: 偏移
     - parameter relation: `= ` /  `>=`  /  `<=` 关系
     - parameter margin: 基于margin的布局方式，默认为`false`
     - returns: 创建的约束
     */
    @discardableResult
    func pin(edge: Edge,
             to otherEdge: Edge,
             of otherView: ConstraintView,
             offset: CGFloat = 0.0,
             relation: LayoutRelation = .equal,
             margin: Bool = false) -> NSLayoutConstraint {
        if margin {
            return layout(attribute: edge.marginAttribute, to: otherEdge.marginAttribute, of: otherView, offset: offset, relation: relation)
        }
        return layout(attribute: edge.attribute, to: otherEdge.attribute, of: otherView, offset: offset, relation: relation)
    }
    
}

public extension SoWrapper where Base: ConstraintView {
    
    /**
     使`view`相对于`Superview`的`边界`进行布局
     
     # Example:
     ```
        let a = UIView()
        superview.addSubview(a)
        a.so.pinToSuperView(insets: .init(top: 5, left: 6, bottom: 5, right: 6))
     /*
      _____________
     |   ___5____  |
     |6 |       | 6|
     |  |_______|  |
     |______5______|
     
     a 上边界相距 superview上边界 为 5
     a 左边界相距 superview左边界 为 5
     a 右边界相距 superview右边界 为 5
     a 下边界相距 superview下边界 为 5
     */
     ```
     
     - parameter edges: 布局边界
     - parameter inset: 上下左右间距， 默认为 (0, 0, 0, 0)
     - parameter margin: 基于margin的布局方式，默认为`false`
     - returns: 创建的约束
     */
    @discardableResult
    func pinToSuperView(insets: ConstraintInsets = .zero, margin: Bool = false) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        constraints.append(pinToSuperview(edge: .top, inset: insets.top, margin: margin))
        constraints.append(pinToSuperview(edge: .leading, inset: insets.left, margin: margin))
        constraints.append(pinToSuperview(edge: .bottom, inset: insets.bottom, margin: margin))
        constraints.append(pinToSuperview(edge: .trailing, inset: insets.right, margin: margin))
        return constraints
    }
    
    /**
     使`view`相对于`Superview`的`边界`进行布局
     
     # Example:
     ```
        let a = UIView()
        superview.addSubview(a)
        a.so.pinToSuperview(edges: .top, .left, .right, inset: 5)
     /*
      _____________
     |   ___5____  |
     |5 |       | 5|
     |  |_______|  |
     |_____________|
     
     a 上边界相距 superview上边界 为 5
     a 左边界相距 superview左边界 为 5
     a 右边界相距 superview右边界 为 5
     */
     ```
     
     - parameter edges: 布局边界
     - parameter inset: 间距， 默认为0
     - parameter margin: 基于margin的布局方式，默认为`false`
     - returns: 创建的约束
     */
    @discardableResult
    func pinToSuperView(edges: Edge..., inset: CGFloat = 0.0, margin: Bool = false) -> [NSLayoutConstraint] {
        let edgesSet = Set(edges)
        var constraints = [NSLayoutConstraint]()
        for edge in edgesSet {
            constraints.append(pinToSuperview(edge: edge, inset: inset, margin: margin))
        }
        return constraints
    }
    
    /**
     使`view`相对于`Superview`的`边界`进行布局
     
     # Example:
     ```
        let a = UIView()
        superview.addSubview(a)
        a.so.pinToSuperview(edge: .top, inset: 30)
     /*
      _____________
     |      30     |
     |   _______   |
     |  |       |  |
     |  |_______|  |
     |_____________|
     
     a 上边界相距 superview 为 30
     
     */
     ```
     
     - parameter edge: 布局边界
     - parameter inset: 间距， 默认为0
     - parameter relation: `= ` /  `>=`  /  `<=` 关系
     - parameter margin: 基于margin的布局方式，默认为`false`
     - returns: 创建的约束
     */
    @discardableResult
    func pinToSuperview(edge: Edge,
                        inset: CGFloat = 0.0,
                        relation: LayoutRelation = .equal,
                        margin: Bool = false) -> NSLayoutConstraint {
        prepareLayout()
        let superview = base.checkSuperview(method: #function)
        var inset = inset
        var relation = relation
        switch edge {
        case .bottom, .right, .trailing:
            inset = -inset
            switch relation {
            case .lessThanOrEqual:
                relation = .greaterThanOrEqual
            case .greaterThanOrEqual:
                relation = .lessThanOrEqual
            default:
                break
            }
        default:
            break
        }
        return pin(edge: edge, to: edge, of: superview, offset: inset, relation: relation, margin: margin)
    }
    
}

#if os(iOS)

@available (iOS 9.0, *)
public extension SoWrapper where Base: ConstraintView {
    
    /**
     使`view`相对于`Superview`的安全区域`边界`进行布局
     
     # Example:
     ```
        let a = UIView()
        superview.addSubview(a)
        a.so.pinToSuperviewSafeArea(insets: .init(top: 5, left: 6, bottom: 5, right: 6))
     /*
      _____________
     |   ___5____  |
     |6 |       | 6|
     |  |_______|  |
     |______5______|
     
     a 上边界相距 superview的安全区域上边界 为 5
     a 左边界相距 superview的安全区域左边界 为 5
     a 右边界相距 superview的安全区域右边界 为 5
     a 下边界相距 superview的安全区域下边界 为 5
     */
     ```
     
     - parameter edges: 布局边界
     - parameter inset: 上下左右间距， 默认为 (0, 0, 0, 0)
     - returns: 创建的约束
     */
    @discardableResult
    func pinToSuperviewSafeArea(insets: ConstraintInsets = .zero) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        constraints.append(pinToSuperviewSafeArea(edge: .top, inset: insets.top))
        constraints.append(pinToSuperviewSafeArea(edge: .leading, inset: insets.left))
        constraints.append(pinToSuperviewSafeArea(edge: .bottom, inset: insets.bottom))
        constraints.append(pinToSuperviewSafeArea(edge: .trailing, inset: insets.right))
        return constraints
    }
    
    /**
     使`view`相对于`Superview`的安全区域`边界`进行布局
     
     # Example:
     ```
        let a = UIView()
        superview.addSubview(a)
        a.so.pinToSuperviewSafeArea(edges: .top, .left, .right, inset: 5)
     /*
      _____________
     |   ___5____  |
     |5 |       | 5|
     |  |_______|  |
     |_____________|
     
     a 上边界相距 superview的安全区域上边界 为 5
     a 左边界相距 superview的安全区域左边界 为 5
     a 右边界相距 superview的安全区域右边界 为 5
     */
     ```
     
     - parameter edges: 布局边界
     - parameter inset: 间距， 默认为0
     - parameter margin: 基于margin的布局方式，默认为`false`
     - returns: 创建的约束
     */
    @discardableResult
    func pinToSuperviewSafeArea(edges: Edge..., inset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        let edgesSet = Set(edges)
        var constraints = [NSLayoutConstraint]()
        for edge in edgesSet {
            constraints.append(pinToSuperviewSafeArea(edge: edge, inset: inset))
        }
        return constraints
    }
    
    /**
     使`view`相对于`Superview`的安全区域`边界`进行布局
     
     # Example:
     ```
        let a = UIView()
        superview.addSubview(a)
        a.so.pinToSuperviewSafeArea(edge: .top, inset: 30)
     /*
      _____________
     |      30     |
     |   _______   |
     |  |       |  |
     |  |_______|  |
     |_____________|
     
     a 上边界相距 superview的安全区域上边界 为 30
     
     */
     ```
     
     - parameter edge: 布局边界
     - parameter inset: 间距， 默认为0
     - parameter relation: `= ` /  `>=`  /  `<=` 关系
     - parameter margin: 基于margin的布局方式，默认为`false`
     - returns: 创建的约束
     */
    @discardableResult
    func pinToSuperviewSafeArea(edge: Edge,
                                inset: CGFloat = 0.0,
                                relation: LayoutRelation = .equal) -> NSLayoutConstraint {
        prepareLayout()
        let superview = base.checkSuperview(method: #function)
        var inset = inset
        let constraint: NSLayoutConstraint
        let top: NSLayoutYAxisAnchor
        let bottom: NSLayoutYAxisAnchor
        let left: NSLayoutXAxisAnchor
        let right: NSLayoutXAxisAnchor
        let leading: NSLayoutXAxisAnchor
        let trailing: NSLayoutXAxisAnchor
        
        if #available(iOS 11.0, tvOS 11.0, *) {
            top = superview.safeAreaLayoutGuide.topAnchor
            bottom = superview.safeAreaLayoutGuide.bottomAnchor
            left = superview.safeAreaLayoutGuide.leftAnchor
            right = superview.safeAreaLayoutGuide.rightAnchor
            leading = superview.safeAreaLayoutGuide.leadingAnchor
            trailing = superview.safeAreaLayoutGuide.trailingAnchor
        } else {
            top = superview.topAnchor
            bottom = superview.bottomAnchor
            left = superview.leftAnchor
            right = superview.rightAnchor
            leading = superview.leadingAnchor
            trailing = superview.trailingAnchor
        }
        
        switch edge {
        case .bottom, .right, .trailing:
            inset = -inset
        default:
            break
        }
        switch (edge, relation) {
        case (.left, .equal):
            constraint = base.leftAnchor.constraint(equalTo: left, constant: inset)
        case (.left, .lessThanOrEqual):
            constraint = base.leftAnchor.constraint(lessThanOrEqualTo: left, constant: inset)
        case (.left, .greaterThanOrEqual):
            constraint = base.leftAnchor.constraint(greaterThanOrEqualTo: left, constant: inset)
            
        case (.right, .equal):
            constraint = base.rightAnchor.constraint(equalTo: right, constant: inset)
        case (.right, .lessThanOrEqual):
            constraint = base.rightAnchor.constraint(lessThanOrEqualTo: right, constant: inset)
        case (.right, .greaterThanOrEqual):
            constraint = base.rightAnchor.constraint(greaterThanOrEqualTo: right, constant: inset)
            
        case (.top, .equal):
            constraint = base.topAnchor.constraint(equalTo: top, constant: inset)
        case (.top, .lessThanOrEqual):
            constraint = base.topAnchor.constraint(lessThanOrEqualTo: top, constant: inset)
        case (.top, .greaterThanOrEqual):
            constraint = base.topAnchor.constraint(greaterThanOrEqualTo: top, constant: inset)
            
        case (.bottom, .equal):
            constraint = base.bottomAnchor.constraint(equalTo: bottom, constant: inset)
        case (.bottom, .lessThanOrEqual):
            constraint = base.bottomAnchor.constraint(lessThanOrEqualTo: bottom, constant: inset)
        case (.bottom, .greaterThanOrEqual):
            constraint = base.bottomAnchor.constraint(greaterThanOrEqualTo: bottom, constant: inset)
            
        case (.leading, .equal):
            constraint = base.leadingAnchor.constraint(equalTo: leading, constant: inset)
        case (.leading, .lessThanOrEqual):
            constraint = base.leadingAnchor.constraint(lessThanOrEqualTo: leading, constant: inset)
        case (.leading, .greaterThanOrEqual):
            constraint = base.leadingAnchor.constraint(greaterThanOrEqualTo: leading, constant: inset)
            
        case (.trailing, .equal):
            constraint = base.trailingAnchor.constraint(equalTo: trailing, constant: inset)
        case (.trailing, .lessThanOrEqual):
            constraint = base.trailingAnchor.constraint(lessThanOrEqualTo: trailing, constant: inset)
        case (.trailing, .greaterThanOrEqual):
            constraint = base.trailingAnchor.constraint(greaterThanOrEqualTo: trailing, constant: inset)
        case (_, _):
            constraint = pinToSuperview(edge: edge, inset: inset, relation: relation)
            return constraint
        }
        constraint.so.install()
        return constraint
    }
    
}

#endif

public extension SoWrapper where Base: ConstraintView {
    
    /**
     创建约束基础方法，可以创建任务约束
     
     # Explain:
     
     与``` NSLayoutConstraint(item:attribute:relatedBy:toItem:attribute:multiplier:constant:)```使用相同
     
     - parameter attribute: 布局属性
     - parameter otherAttribute: 相对于`otherView`的布局属性
     - parameter otherView: 相对布局的 `view`
     - parameter offset: 偏移 / 长度
     - parameter relation: `= ` /  `>=`  /  `<=` 关系
     - returns: 创建的约束
     */
    @discardableResult
    func layout(attribute: LayoutAttribute,
                to otherAttribute: LayoutAttribute,
                of otherView: ConstraintView?,
                offset: CGFloat = 0.0,
                multipilier: CGFloat = 1.0,
                relation: LayoutRelation = .equal) -> NSLayoutConstraint {
        prepareLayout()
        let constraint = NSLayoutConstraint(item: base, attribute: attribute, relatedBy: relation, toItem: otherView, attribute: otherAttribute, multiplier: multipilier, constant: offset)
        constraint.so.install()
        return constraint
    }
    
}

internal extension ConstraintView {
    
    /**
     根据`attribute`方向进行对齐
     
     # Warning
     
     `axis`为 `vertical`时，`attribute`只能为`vertical/left/right/leading/trailing`
     
     `axis`为其他值时，`attribute`只能为`horizontal/fisrtBaseline/lastBaseline/top/bottom`
     
     - parameter attribute: 对齐的方向
     - parameter otherView: 对齐的`view`
     - parameter axis: 排列的方向
     - parameter method: 当前检测时调用的方法
     - returns: 创建的约束
     */
    @discardableResult
    func align(attribute: Alignment, to otherView: ConstraintView, for axis: Axis, method: String) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        switch attribute {
        case .horizontal:
            assert(axis != .vertical,
                   getAssertMessage(attribute: attribute, otherView: otherView, axis: axis, method: method))
            constraint = so.align(axis: .vertical, to: otherView)
        case .fisrtBaseline:
            assert(axis != .vertical,
                   getAssertMessage(attribute: attribute, otherView: otherView, axis: axis, method: method))
            constraint = so.align(axis: .fisrtBaseline, to: otherView)
        case .lastBaseline:
            assert(axis != .vertical,
                   getAssertMessage(attribute: attribute, otherView: otherView, axis: axis, method: method))
            constraint = so.align(axis: .lastBaseline, to: otherView)
        case .top:
            assert(axis != .vertical,
                   getAssertMessage(attribute: attribute, otherView: otherView, axis: axis, method: method))
            constraint = so.pin(edge: .top, to: .top, of: otherView)
        case .bottom:
            assert(axis != .vertical,
                   getAssertMessage(attribute: attribute, otherView: otherView, axis: axis, method: method))
            constraint = so.pin(edge: .bottom, to: .bottom, of: otherView)
        case .vertical:
            assert(axis == .vertical,
                   getAssertMessage(attribute: attribute, otherView: otherView, axis: axis, method: method))
            constraint = so.align(axis: .horizontal, to: otherView)
        case .left:
            assert(axis == .vertical,
                   getAssertMessage(attribute: attribute, otherView: otherView, axis: axis, method: method))
            constraint = so.pin(edge: .left, to: .left, of: otherView)
        case .right:
            assert(axis == .vertical,
                   getAssertMessage(attribute: attribute, otherView: otherView, axis: axis, method: method))
            constraint = so.pin(edge: .right, to: .right, of: otherView)
        case .leading:
            assert(axis == .vertical,
                   getAssertMessage(attribute: attribute, otherView: otherView, axis: axis, method: method))
            constraint = so.pin(edge: .leading, to: .leading, of: otherView)
        case .trailing:
            assert(axis == .vertical,
                   getAssertMessage(attribute: attribute, otherView: otherView, axis: axis, method: method))
            constraint = so.pin(edge: .trailing, to: .trailing, of: otherView)
        }
        return constraint
    }
    
    private func getAssertMessage(attribute: Alignment,
                                  otherView: ConstraintView,
                                  axis: Axis,
                                  method: String) -> String {
        return
            """
            \n\n***************************\n
            提示:       当 axis 为 \(axis) 时，attribute 不能使用 \(attribute)，会导致约束冲突;
            Method:    \(method);
            View:      \(self);
            OtherView: \(otherView);
            \n***************************\n\n
            """
    }
    
}

internal extension ConstraintView {
    
    /// 检测 与 `otherView` 是否存在相同的`Superview`
    /// - Parameters:
    ///   - otherView: 相比较的 `view`
    ///   - method: 当前检测时调用的方法
    /// - Returns: 相同的`Superview`
    @discardableResult
    func checkCommonSuperview(with otherView: ConstraintView, method: String) -> ConstraintView {
        var superview: ConstraintView?
        var startView: ConstraintView? = self
        repeat {
            if let s = startView, otherView.isDescendant(of: s) {
                superview = s
            }
            startView = startView?.superview
        } while startView != nil && superview != nil
        guard let s = superview else {
            assert(false,
                   """
                   \n\n***************************\n
                   提示:       两个View需要有共同的Superview;
                   Method:    \(method);
                   View:      \(self);
                   OtherView: \(otherView);
                   \n***************************\n\n
                   """)
        }
        return s
    }
    
    /// 检测是否存在  ` Superview `
    /// - Parameter method: 当前检测时调用的方法
    /// - Returns: `Superview`
    @discardableResult
    func checkSuperview(method: String) -> ConstraintView {
        guard let superview = self.superview else {
            assert(false,
                   """
                   \n\n***************************\n
                   提示:       View的Superview不能为空;
                   Method:    \(method);
                   View:      \(self);
                   \n***************************\n\n
                   """)
        }
        return superview
    }
    
}
