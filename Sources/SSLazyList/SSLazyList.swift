//
//  SSLazyList.swift
//  SSLazyList
//
//  Created by SmartSense Consulting Solutions Pvt. Ltd. on 17/05/24.
//

import Foundation
import SwiftUI
import Combine

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
    
    public var configuration: SSConfigLazyList
    
    //MARK: - Observing Properties
    /// The configuration object for the lazy list.
    ///
    /// This object holds the configuration settings for the lazy list view.
    /// Changes to this object trigger updates to the view's layout and content.
    @State public var isActive_PullToRefresh = true
    @State public var isRefreshing = false
    @State public var refreshRect : CGRect = .zero
    @State public var refreshScrollRect : CGRect = .zero
    
    @State public var isActive_LoadMore = true
    @State public var isPageLoading = false
    @State public var pagerViewRect : CGRect = .zero
    @State public var pageScrollRect : CGRect = .zero
    
    @State var cancellable : AnyCancellable?
    
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
        self.configuration = configuration //StateObject(wrappedValue: configuration)
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
            let firstItemIdx = dataList.first!.id
            let lastItemIdx = dataList.last!.id
            VStack{
                
                VStack{                    
                    if (self.isRefreshing){
                        configuration.pullToRefreshType?.refreshingView
                    }
                }
                
                ZStack{
                    
                    if(self.isRefreshing == false && self.isPageLoading == false){
                        //pulldown to refresh
                        if(self.isActive_PullToRefresh && (configuration.pullToRefreshType != nil) && refreshRect != .zero){
                            VStack{
                                configuration.pullToRefreshType?.view
                                    .modifier(SSListRefresher(isActive:$isActive_PullToRefresh, isRefreshing: self.$isRefreshing, pullDownRect: self.$refreshScrollRect, displayRect: self.$refreshRect, onRefresh: {closure in
                                        configuration.dataLoadingClosure = closure
                                        configuration.pullToRefreshType?.callback(closure)
                                        if (configuration.pageLoadingType != nil && self.isActive_LoadMore != true){
                                            self.isActive_LoadMore = true
                                        }
                                    }))
                                Spacer()
                            }
                        }
                        
                        //pullup to load page
                        if(self.isActive_LoadMore && pagerViewRect != .zero){
                            if (configuration.pageLoadingType?.type == .onPullUp || configuration.pageLoadingType?.type == .onLastRow){
                                let notifyVariableHeight = configuration.pageLoadingType?.type == .onPullUp ? -18 : -self.pagerViewRect.height + 18
                                
                                VStack{
                                    Spacer()
                                    configuration.pageLoadingType?.view
                                        .modifier(SSNewPageLoader(isActive:$isActive_LoadMore, isPageLoading: self.$isPageLoading, pullUpRect: self.$pageScrollRect, displayRect: self.$pagerViewRect,notifyVariableHeight: notifyVariableHeight, onPageLoad: { closure in
                                            configuration.dataLoadingClosure = closure
                                            configuration.pageLoadingType?.callback(closure)
                                        }))
                                }
                            }
                        }
                    }
                    
                    GeometryReader { listGeoReader in
                        List{
                            if (refreshRect == .zero && (configuration.pullToRefreshType != nil)){
                                self.setUpRefreshRect()
                            }
                            Group {
                                self.rowContent(dataList.first!)
                                    .conditionalModifier(apply: (configuration.pullToRefreshType != nil) && self.isRefreshing == false && self.isPageLoading == false, applier: { view in
                                        return view.modifier(SSListCellFrameObserver(scrollRect: self.$refreshScrollRect))//.animation(.easeInOut(duration: 0.1), value: self.refreshScrollRect)
                                    }).conditionalModifier(apply: firstItemIdx == lastItemIdx, applier: { view in
                                        return applyLastRowModifier(view: view, listGeoReader: listGeoReader)
                                    }).conditionalModifier(apply: (configuration.newCellAnimation != SSCellAnimationType.none && self.isRefreshing == false && self.isPageLoading == false), applier: { view in
                                        view.modifier(SSListCellAnimator(newCellAnimationType: configuration.newCellAnimation, scrollPosition: .zero ))
                                    })
                                
                                ForEach(dataList){ item in
                                    if (firstItemIdx != item.id && lastItemIdx != item.id){
                                        self.rowContent(item)
                                            .conditionalModifier(apply: (configuration.newCellAnimation != SSCellAnimationType.none && self.isRefreshing == false && self.isPageLoading == false), applier: { view in
                                            view.modifier(SSListCellAnimator(newCellAnimationType: configuration.newCellAnimation, scrollPosition: .zero ))
                                        })
                                    }
                                }
                                
                                if (firstItemIdx != lastItemIdx){
                                    applyLastRowModifier(view: self.rowContent(dataList.last!), listGeoReader: listGeoReader).conditionalModifier(apply: (configuration.newCellAnimation != SSCellAnimationType.none && self.isRefreshing == false && self.isPageLoading == false), applier: { view in
                                        view.modifier(SSListCellAnimator(newCellAnimationType: configuration.newCellAnimation, scrollPosition: .zero )).conditionalModifier(apply: (configuration.newCellAnimation != SSCellAnimationType.none && self.isRefreshing == false && self.isPageLoading == false), applier: { view in
                                            view.modifier(SSListCellAnimator(newCellAnimationType: configuration.newCellAnimation, scrollPosition: .zero ))
                                        })
                                    })
                                }
                            }
                        }
                        //.animation(nil, value: self.isRefreshing)
                        
                        if (pagerViewRect == .zero && configuration.pageLoadingType?.type == .onPullUp){
                            self.setUpPageLoaderRect(rectList: listGeoReader.frame(in: .named("SSListPaggerNameSpace")))
                        }
                    }
                }
                
                VStack{
                    
                    if (self.isPageLoading){
                        configuration.pageLoadingType?.refreshingView
                    }
                }
            }
            .animation(.linear(duration: 0.3), value: self.isRefreshing)
            .coordinateSpace(name: "SSListPaggerNameSpace")
            .environment(\.defaultMinListRowHeight, 1)
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
    
    @ViewBuilder
    func setUpRefreshRect()-> some View{
        configuration.pullToRefreshType?.view.hidden().frame(maxWidth: .infinity).background(
            GeometryReader { gr in
                Color.clear
                let _ = DispatchQueue.main.async(execute: {
                    self.refreshRect = gr.frame(in: .named("SSListPaggerNameSpace"))
                })
            }
        )
    }
    
    @ViewBuilder
    func setUpPageLoaderRect(rectList : CGRect)-> some View{
        
        configuration.pageLoadingType?.view.hidden().opacity(0).frame(maxWidth: .infinity).background(
            GeometryReader { gr in
                Color.clear
                let _ = DispatchQueue.main.async(execute: {
                    let viewFrame = gr.frame(in: .named("SSListPaggerNameSpace"))
                    var newRect = self.pagerViewRect

                    if newRect.minX == 0 {
                        newRect.origin.x = rectList.minX
                    }
                    if newRect.minY == 0 {
                        newRect.origin.y = rectList.height
                    }
                    if viewFrame.width != 0 {
                        newRect.size.width = viewFrame.width
                    }
                    if viewFrame.height != 0 {
                        newRect.size.height = viewFrame.height
                    }
                    self.pagerViewRect = newRect
                })
            }
        )
    }
    
    func setUpLastRowLoaderRect(rectList : CGRect, rowRect: CGRect)-> Void{
        let _ = DispatchQueue.main.async(execute: {
            let viewFrame = rowRect
            var newRect = self.pagerViewRect

            if newRect.minX == 0 {
                newRect.origin.x = rectList.minX
            }
            if newRect.minY == 0 {
                newRect.origin.y = rectList.height + viewFrame.height /** 2*/
            }
            if viewFrame.width != 0 {
                newRect.size.width = viewFrame.width
            }
            if viewFrame.height != 0 {
                newRect.size.height = viewFrame.height
            }
            self.pagerViewRect = newRect
        })
    }
    
    
    @ViewBuilder
    fileprivate func applyLastRowModifier<T:View>(view: T, listGeoReader: GeometryProxy) -> some View {
        view
            .conditionalModifier(apply: (self.isRefreshing == false && self.isPageLoading == false), applier: { view in
                view.conditionalModifier(apply: configuration.pageLoadingType?.type == .onPullUp) { view in
                    view.modifier(SSListCellFrameObserver(scrollRect: self.$pageScrollRect))
                }
                .conditionalModifier(apply: configuration.pageLoadingType?.type == .onLastRow){
                    view in
                    view.modifier(SSListCellFrameObserver(scrollRect: self.$pageScrollRect)).background(
                        
                    GeometryReader { readerLastRow in
                        Color.clear
                        if (pagerViewRect == .zero){
                            let _ = self.setUpLastRowLoaderRect(rectList: listGeoReader.frame(in: .local), rowRect: readerLastRow.frame(in: .named("SSListPaggerNameSpace")))
                        }
                    })
                }
            })//.animation(.easeInOut(duration: 0.1), value: self.pageScrollRect)
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
    
    @ViewBuilder
    func viewProxy<Content:View>(applier:(Self)->(Content)) -> some View {
        applier(self)
    }
    
    func getViewFrameProxy(frame:@escaping (CGRect)->()) -> some View {
        self.background(
            GeometryReader { reader in
                Color.blue//.frame(maxWidth: .infinity, maxHeight: .infinity)
                let _ = frame(reader.frame(in: .global))
            }
        )
    }
}




