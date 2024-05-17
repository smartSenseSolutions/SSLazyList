//
//  SSConfigLazyList.swift
//  SSLazyList
//
//  Created by Kalpesh on 17/05/24.
//

import Foundation
import SwiftUI

/// Configuration class for SSLazyList settings and customization.
public class SSConfigLazyList:ObservableObject {
    
    //MARK: - Properties
    /// The type of animation for displaying new cells in the list.
    var newCellAnimation : SSCellAnimationType = .none
    
    /// The custom view type to be displayed while loading data.
    var loadingView: SSViewType = .none
    
    /// The custom view type to be displayed when no data is found.
    var dataNotFoundView: SSViewType = .none

    //MARK: - Constructors
    /// default constructor allowing developer to customise  `SSConfigLazyList` later
    public init(){}
    
    /// Initializes the configuration with the specified animation type for new cells.
    ///
    /// - Parameter animator: The type of animation for displaying new cells in the list.
    public init(animator: SSCellAnimationType) {
        self.newCellAnimation = animator
    }
    
    /// Initializes the configuration with the specified custom view type for progress indicator.
    ///
    /// - Parameter progressIndicatorType: The custom view type to be displayed as a progress indicator.
    public init(progressIndicatorType: SSViewType) {
        self.loadingView = progressIndicatorType
    }
    
    /// Initializes the configuration with the specified custom view type for data not found.
    ///
    /// - Parameter dataNotFoundType: The custom view type to be displayed when no data is found.
    public init(dataNotFoundType: SSViewType) {
        self.dataNotFoundView = dataNotFoundType
    }
    
    //MARK: - Functions for configurations
    /// Sets the animation type for displaying new cells in the list.
    ///
    /// - Parameter animator: The type of animation for displaying new cells.
    public func setNewCellAnimation(animator: SSCellAnimationType) {
        self.newCellAnimation = animator
    }
    
    /// Sets the custom view type to be displayed while loading data.
    ///
    /// - Parameter viewType: The custom view type to be displayed as a loading indicator.
    public func setLoadingView(viewType: SSViewType) {
        self.loadingView = viewType
    }
    
    /// Sets the custom view type to be displayed when no data is found.
    ///
    /// - Parameter viewType: The custom view type to be displayed when no data is found.
    public func setNoDataView(viewType: SSViewType) {
        self.dataNotFoundView = viewType
    }
    
}
