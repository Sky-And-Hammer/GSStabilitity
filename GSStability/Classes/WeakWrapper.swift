//
//  WeakWrapper.swift
//  GSStability
//
//  Created by 孟钰丰 on 2018/2/6.
//

import Foundation
/// A wrapper struct for weak object for used
/// For example:
///
///     var view: UIView? = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
///     let wrapper = Wrapper.init(view)
///     wrapper.value == nil -> false
///     view = nil
///     wrapper.value == nil -> true
public struct WeakWrapper<T: AnyObject> {
    public weak var value: T?
    
    public init(_ value: T? = nil) { self.value = value }
}
