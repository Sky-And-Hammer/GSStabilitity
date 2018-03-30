//
//  Errors.swift
//  GSStabilitity
//
//  Created by 孟钰丰 on 2017/12/15.
//  Copyright © 2017年 孟钰丰. All rights reserved.
//

import Foundation

/// A type that describe an error's reason
public protocol GSErrorReason {
    
    /// error reason debug description, '' by default
    var localizedDescription: String { get }
}

extension GSErrorReason { var localizedDescription: String { return "" } }

/// A type that error returned by something. It encompasses a few different types of errors, each with their own associated reasons.
///
/// For example:
///
///     enum APIError: GSError {
///
///         enum NetworkWrongReason {
///             case noNetwork
///             case timeout
///         }
///
///         enum ServerWrongReason {
///             case noResponse
///             case stateWrong(stateCode: Int)
///             case apiWrong(apiCode: Int)
///         }
///
///         case networkWrong(reason: NetworkWrongReason)
///         case serverWrong(reason: ServerWrongReason)
///     }
public protocol GSError: LocalizedError {}


