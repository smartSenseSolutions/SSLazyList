//
//  SSLazyList.swift
//  SSLazyList
//
//  Created by Kalpesh on 17/05/24.
//

import Foundation
import SwiftUI

/// A SSLazyList view that displays content based on a collection of identifiable data.
///
/// This view is generic over two types: `DataValue`, which must conform to the `Identifiable` protocol,
/// and `Content`, which represents the content view to be displayed.
public struct SSLazyList<DataValue, Content>: View where DataValue:Identifiable, Content:View {
    
    //MARK: - Properties
    /// An optional array of data values to be displayed in the list.
    ///
    /// This property holds the data values to be presented by the list view.
    /// If `data` is `nil`, the list will be empty or SSLazyList will show `No data available` view if configured.
    var data: [DataValue]?
    
    /// A closure that produces the content view for each data value.
    ///
    /// This closure is called for each data value in the list to create the corresponding content view.
    let rowContent: (DataValue) -> Content
    
    //MARK: - Observing Properties
    /// The configuration object for the lazy list.
    ///
    /// This object holds the configuration settings for the lazy list view.
    /// Changes to this object trigger updates to the view's layout and content.
    @StateObject public var configuration: SSConfigLazyList
        
    // MARK: - Constructor
    /// Initializes a lazy list view with the provided data, row content closure, and configuration.
    ///
    /// - Parameters:
    ///   - data: An optional array of data values to be displayed in the list.
    ///   - rowContent: A closure that produces the content view for each data value.
    ///   - configuration: The configuration object for the lazy list.
    public init(data: [DataValue]?, rowContent: @escaping (DataValue) -> Content, configuration: SSConfigLazyList) {
        self.data = data
        self.rowContent = rowContent
        self._configuration = StateObject(wrappedValue: configuration)
    }
    
    /// The body of the lazy list view.
    ///
    /// This property defines the content of the lazy list view.
    /// It returns the `loadListWrapper` property, which represents the main content of the view.
    public var body: some View{
        loadListWrapper
    }
    
    //MARK: - Views
    /// The loadListWrapper view builder applies configured set of plugins to the  SwiftUI List.
    ///
    /// This property constructs the main content view for the lazy list.
    /// It uses a `ViewBuilder` to allow for conditional view construction.
    @ViewBuilder
    var loadListWrapper: some View {
        if let dataList = data, dataList.count > 0{
            List(dataList) { item in
                self.rowContent(item)
                    .conditionalModifier(apply: (configuration.newCellAnimation != SSCellAnimationType.none), applier: { view in
                        view.modifier(SSListCellAnimator(newCellAnimationType: configuration.newCellAnimation, scrollPosition: .zero ))
                    })
            }
        }
        else {
            if (data?.count == 0 && self.configuration.dataNotFoundView != .none){
                getDataNotFoundView(type: self.configuration.dataNotFoundView)
            }
            else if (self.configuration.loadingView != .none) {
                getDefaultProgressView(type: self.configuration.loadingView)
            }
        }
    }
}

extension SSLazyList{
    
    //MARK: - Views
    /// A private computed property representing the default progress view.
    ///
    /// This view combines a standard progress indicator with a loading message.
    ///
    /// - Returns: A `View` displaying the progress indicator and loading message.
    private var defaultProgressView: some View {
        VStack(alignment: .center) {
            HStack(spacing: 8) {
                ProgressView()
                Text("Loading data...")
            }
        }
    }

    /// A private computed property representing the default "No Data Available" view.
    ///
    /// This view displays a message indicating that no data is available.
    ///
    /// - Returns: A `View` displaying the "No Data Found" message.
    private var defaultNoDataAvailableView : some View {
        VStack {
            Text("No data found.")
                .foregroundColor(.gray)
        }
    }
    
    @ViewBuilder
    func getDataNotFoundView(type:SSViewType) -> some View{
        switch type {
        case .system:
            defaultNoDataAvailableView
        case .customView(let anyView):
            anyView
        case .none:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func getDefaultProgressView(type:SSViewType) -> some View{
        switch type {
        case .system:
            defaultProgressView
        case .customView(let anyView):
            anyView
        case .none:
            EmptyView()
        }
    }
}

//MARK: - Extension ConditionalModifier
fileprivate extension View{
    /// Conditionally applies a modifier to the view based on a given condition.
    ///
    /// - Parameters:
    ///   - apply: A boolean value indicating whether to apply the modifier.
    ///   - applier: A closure that receives `Self` if the condition is true.
    /// - Returns: The view with the modifier applied conditionally.
    @ViewBuilder
    func conditionalModifier<Content:View>(apply:Bool, applier:(Self)->(Content)) -> some View {
        if apply {
            applier(self)
        }else {
            self
        }
    }
}

