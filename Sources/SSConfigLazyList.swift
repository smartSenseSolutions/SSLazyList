//
//  SSConfigLazyList.swift
//  SSLazyList
//
//  Created by SmartSense Consulting Solutions Pvt. Ltd. on 17/05/24.
//

import Foundation
import SwiftUI
import Combine

/// Configuration class for SSLazyList settings and customization.
public class SSConfigLazyList {
    
    //MARK: - Properties
    /// The type of animation for displaying new cells in the list.
    var newCellAnimation : SSCellAnimationType = .none
    var pullToRefreshType : SSPullToRefresh?
    var pageLoadingType : SSLoadMore?
    
    /// The custom view type to be displayed while loading data.
    var loadingView: SSViewType = .none
    
    /// The custom view type to be displayed when no data is found.
    var dataNotFoundView: SSViewType = .none
    
    public var dataLoadingClosure : ((Bool)->())? = nil

    //MARK: - Constructors
    /// default constructor allowing developer to customise  `SSConfigLazyList` later
    public init(){}
    
    /// Initializes the configuration with the specified animation type for new cells.
    ///
    /// - Parameter animator: The type of animation for displaying new cells in the list.
    public convenience init(animator: SSCellAnimationType) {
        self.init()
        self.newCellAnimation = animator
    }
    
    /// Initializes the configuration with the specified custom view type for progress indicator.
    ///
    /// - Parameter progressIndicatorType: The custom view type to be displayed as a progress indicator.
    public convenience init(loadingView: SSViewType) {
        self.init()
        self.loadingView = loadingView
    }
    
    /// Initializes the configuration with the specified custom view type for data not found.
    ///
    /// - Parameter dataNotFoundType: The custom view type to be displayed when no data is found.
    public convenience init(dataNotFoundType: SSViewType) {
        self.init()
        self.dataNotFoundView = dataNotFoundType
    }
    
    /// Initializes the configuration with the specified struct for pull to refresh.
    ///
    /// - Parameter pullToRefresh: The struct with cusumable closures like loadview, loading view, and a action trigger.
    public convenience init(pullToRefresh: SSPullToRefresh) {
        self.init()
        self.pullToRefreshType = pullToRefresh
        
    }
    
    /// Initializes the configuration with the specified struct for load more data views provider and completion closures
    ///
    /// - Parameter pageLoadingType: The struct with cusumable closures like loadview, loading view, and a action trigger.
    public convenience init(pageLoadingType: SSLoadMore) {
        self.init()
        self.pageLoadingType = pageLoadingType
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
    
    /// Sets the pull to refresh to be displayed on pulling down list from top edge.
    ///
    /// - Parameter viewType: pull to refresh configuration, with depending views and trigger action.
    public func setReloadType(viewType: SSPullToRefresh) {
        self.pullToRefreshType = viewType
    }
    
    /// Sets the loadmore view to be displayed on pulling up list from bottom edge.
    ///
    /// - Parameter viewType: pullup to load more configuration, with depending views and trigger action.
    public func setLoadMoreType(viewType: SSLoadMore) {
        self.pageLoadingType = viewType
    }
    
    /// OnResponseAllowLoading Helps to stop active loading out side of configuration trigger.
    ///
    /// - Parameter allow: Bool value true/false to stop or continue loading of data.
    public func onResponseAllowLoading(allow: Bool) {
        self.dataLoadingClosure?(allow)
    }
}
