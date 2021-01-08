//
//  NSLayoutConstraint+SoLayout.swift
//  SoLayout
//
//  Created by liqi on 2020/12/30.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

/// 在回调中设置约束
public typealias LayoutConstraintsAction = ()->()

public extension SoWrapper where Base: NSLayoutConstraint {
    
    /**
     安装`约束`，并不一定激活`约束`
     */
    func install() {
        /// 1. 设置`约束优先级`
        base.setPriority()
        /// 2. 设置`约束标识符`
        base.setIdentifier()
        /// 3. 判断是否需要激活`约束`
        if NSLayoutConstraint.preventToActivateConstraints {
            /// a. 当不需要激活`约束`时，把所有`约束`存储起来，用于后面获取所有未激活的`约束`
            NSLayoutConstraint.currentCreatedConstraintsAppend(constraints: [base])
        } else {
            base.isActive = true
        }
    }
    
    /// 使`约束`失效
    func remove() {
        base.isActive = false
    }
    
}

public extension SoWrapper where Base == NSLayoutConstraint.Type {
    
    /**
     
     - parameter isInstalling: 是否需要激活`约束`，默认为 `false`
     - parameter action: 在回调中设置约束
     */
    func create(isInstalling: Bool = false,
                for action: LayoutConstraintsAction) -> [NSLayoutConstraint]? {
        /// 1. 首先创建保存`约束`的数组，将`约束组`保存到`全局约束存储队列`中
        base.createdConstraints.append([])
        /// 2. 当每个`约束`调用 `constraint.install()`方法时，会获取当前队列的`约束组`
        /// 此时会将`约束`保存到当前`约束组`中，并不会激活`约束`
        action()
        /// 3. 所有`约束`都已经添加到`全局约束存储队列`当前`约束组`中，获取所有未激活的`约束`
        let createdCon = base.currentCreatedConstraints
        /// 4. `全局约束存储队列`移除当前`约束组`
        base.createdConstraints.removeLast()
        /// 5. 当前`约束组`是否需要激活
        if isInstalling {
            ///`installConstraints`方法中，根据全局变量`isInstallingContraints`标记判断是否需要激活
            /// 所以设置 `isInstallingContraints = true`
            /// 激活完成后，设置`isInstallingContraints = false`，默认为不需要激活
            base.isInstallingContraints = true
            createdCon.so.installConstraints()
            base.isInstallingContraints = false
        }
        return createdCon
    }
}

public extension SoWrapper where Base == NSLayoutConstraint.Type {
    
    /// 批量为`约束`设置`优先级`
    /// - Parameters:
    ///   - priority: 为约束设置的`优先级`
    ///   - action: 在回调中设置约束
    func setPriority(with priority: LayoutPriority,
                     for action: LayoutConstraintsAction ) {
        /// 1. 添加`优先级`到队列
        base.priorities.append(priority)
        /// 2. 当每个`约束`调用 `constraint.install()`方法时，会获取当前队列的`优先级`
        ///   为每个`约束`设置约束优先级
        action()
        /// 3. 设置完毕，移除当前队列中设置的`优先级`
        base.priorities.removeLast()
    }
    
}

public extension SoWrapper where Base == NSLayoutConstraint.Type {
    
    /// 批量为`约束`设置`标识符`
    /// - Parameters:
    ///   - identifier: 为约束设置的`标识符`
    ///   - action: 在回调中设置约束
    func setIdentifier(with identifier: String,
                       for action: LayoutConstraintsAction ) {
        /// 1. 添加`标识符`到队列
        base.identifiers.append(identifier)
        /// 2. 当每个`约束`调用 `constraint.install()`方法时，会获取当前队列的`标识符`
        ///   为每个`约束`设置`标识符`
        action()
        /// 3. 设置完毕，移除当前队列中设置的`标识符`
        base.identifiers.removeLast()
    }
    
}

internal extension NSLayoutConstraint {
    
    /// 存储`优先级`的全局队列
    static var priorities = [LayoutPriority]()
    
    /// 获取当前最新的`优先级`
    static var currentPriority: LayoutPriority {
        return priorities.last ?? .required
    }
    
    /// 当队列不为空时，说明正在为`约束`设置`优先级`
    static var isSettingPriority: Bool {
        return !priorities.isEmpty
    }
    
    /**
     为`约束`设置`优先级`
     
     # Explain:
     
     通过在`NSLayoutConstraint.currentPriority`队列中获取当前`优先级`，来设置约束
     */
    func setPriority() {
        if NSLayoutConstraint.isSettingPriority {
            priority = NSLayoutConstraint.currentPriority
        }
    }
    
}

// MARK: - Private

internal extension NSLayoutConstraint {
    
    /// 存储`标识符`的全局队列
    static var identifiers = [String]()
    
    /// 获取当前最新的`标识符`
    static var currentIdentifier: String? {
        return identifiers.last
    }
    
    /**
     为`约束`设置`标识符`，用于Debug
     
     # Explain:
     
     通过在`NSLayoutConstraint.identifiers`队列中获取当前`标识符`，来设置约束
     */
    func setIdentifier() {
        if let identifier = NSLayoutConstraint.currentIdentifier {
            self.identifier = identifier
        }
    }
    
}

internal extension NSLayoutConstraint {
    
    /// `全局约束存储队列`，存储创建的`约束组`
    static var createdConstraints = [[NSLayoutConstraint]]()
    
    /// 是否激活当前 `约束组`中的`约束`
    static var isInstallingContraints = false
    
    /// 获取当前正在创建的`约束`
    static var currentCreatedConstraints: [NSLayoutConstraint] {
        return createdConstraints.last ?? []
    }
    
    /// 是否阻止激活正在创建的`约束`
    static var preventToActivateConstraints: Bool {
        return !isInstallingContraints && createdConstraints.count > 0
    }
    
    /// 把`约束`添加到队列当前的`约束组`中
    /// - Parameter constraints: 部分`约束`
    class func currentCreatedConstraintsAppend(constraints: [NSLayoutConstraint]) {
        var current = currentCreatedConstraints
        current.append(contentsOf: constraints)
        createdConstraints.removeLast()
        createdConstraints.append(current)
    }
    
}
