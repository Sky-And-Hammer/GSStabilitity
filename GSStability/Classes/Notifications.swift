//
//  Notifications.swift
//  GSStabilitity
//
//  Created by 孟钰丰 on 2017/12/15.
//  Copyright © 2017年 孟钰丰. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    private static let notificationPrefix = "com.Sky-And-Hammer.ios.GS."
    
    /// Used as a namespace for business block. the notification's name is 'com.Sky-And-Hammer.ios.GS.you_name'
    ///
    /// For example:
    ///
    ///     public extension Notification.Name {
    ///         public static let networkStateChanged = Notification.Name.named(by: "networkStateChanged")
    ///         public static let networkStateChanged = Notification.Name.named(by: "networkStateChanged")
    ///     }
    public static func named(by: String) -> Notification.Name { return Notification.Name.init(notificationPrefix + by) }
}
