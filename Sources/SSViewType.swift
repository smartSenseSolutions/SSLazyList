//
//  SSViewType.swift
//  SSLazyList
//
//  Created by SmartSense Consulting Solutions Pvt. Ltd. on 17/05/24.
//

import Foundation
import SwiftUI

/// This enum represents the type with it's associate view if any.
///
/// Dependency : SSDefaultViewType
///
/// - none: default value, this type will not show any view on particular event
/// - system: It is an enum which denotes different type of view for events
/// - customView: this type will force developer to provide view to show on events

public enum SSViewType: Equatable, CustomStringConvertible {
    
    //MARK: - Default View Types
    /// This enum represents the types of framework provided views.
    ///
    /// - progressIndicator: While waiting for network response it helps by displaying activity indicator.
    /// - dataNotFound: in case, Server has returned no data then it helps to shows pariticular view
    public enum SSDefaultViewType{
        case progressIndicator
        case dataNotFound
        case loadingHeader
    }
    
    //MARK: - Enum Cases
    case none
    case system
    case customView(AnyView)

    //MARK: - CustomStringConvertible
    /// A textual description of the enum case.
    ///
    /// - Returns: A string describing the enum case.
    ///
    public var description: String {
        switch self {
        case .none:
            "none"
        case .system:
            "system"
        case .customView(_):
            "customView"
        }
    }
    
    //MARK: - Equitable
    /// Compares two instances of `SSViewType` for equality based on their descriptions.
    public static func == (lhs: SSViewType, rhs: SSViewType) -> Bool {
        lhs.description == rhs.description
    }
}

