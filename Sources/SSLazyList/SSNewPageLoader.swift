//
//  SSNewPageLoader.swift
//  SSLazyList
//
//  Created by SmartSense Consulting Solutions Pvt. Ltd. on 03/06/24.
//

import Foundation
import SwiftUI
import Combine

///
/// `SSNewPageLoader` adds loading and observes position and triggers action at certain point of position
///
public struct SSNewPageLoader : ViewModifier {
    
    let notifyVariableHeight : CGFloat
    
    let pageLoadingDetector: PassthroughSubject<Bool, Never>
    public let pageLoadPublisher: AnyPublisher<Bool, Never>
    
    private var onPageLoad : ((@escaping(Bool)->())->())? = nil
    
    @Binding var pullUpRect : CGRect
    @Binding var displayRect : CGRect
    
    
    init(isActive:Binding<Bool>, isPageLoading:Binding<Bool>, pullUpRect : Binding<CGRect>, displayRect: Binding<CGRect>,notifyVariableHeight:CGFloat = 0,onPageLoad: @escaping ((@escaping(Bool)->())->())) {
        
        let pageLoadingDetector = PassthroughSubject<Bool,Never>()
        self.pageLoadPublisher = pageLoadingDetector
            .removeDuplicates()
            .debounce(for: .milliseconds(10), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
        self.pageLoadingDetector = pageLoadingDetector
        self.onPageLoad = onPageLoad
        
        self._isPageLoading = isPageLoading
        self._pullUpRect = pullUpRect
        self._displayRect = displayRect
        self._isActive = isActive
        self.notifyVariableHeight = notifyVariableHeight
    }
    
    @State var enableCallback : Bool = true
    
    @Binding public var isPageLoading :Bool
    
    @State var stopRefresh : Bool = false
    @Binding var isActive : Bool

    
    public func body(content: Content) -> some View {
        
        self.loadMoreView(view: content, pullUpRect: pullUpRect, displayRect: displayRect)
            .onReceive(self.pageLoadPublisher, perform: { value in
                enableCallback = false
                if (!stopRefresh && !isPageLoading){
                    self.stopRefresh = true
                    self.isPageLoading = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                        pullUpRect = .zero
                        self.onPageLoad?(stopRefreshing)
                    })
                }
            })
    }
    
    @ViewBuilder
    func loadMoreView<Content:View>(view:Content, pullUpRect:CGRect, displayRect: CGRect)-> some View {
        if (pullUpRect == .zero){
            view.opacity(0).hidden()
        }
        else{
            Group{
                let newY = pullUpRect.minY

                if (newY <= displayRect.minY){

                    let _ = trackRefreshableEvent(pullUpRect, displayRect: displayRect, additionalScrollHeight: notifyVariableHeight)
                    
                    let newHeight = displayRect.minY - newY
                    
                    let refOpacity = newHeight / displayRect.height
                    
                    let validOpacity = min(1, refOpacity)
                    
                    view
                        .frame(width: displayRect.width, height: newHeight < 0 ? 0 : newHeight > displayRect.height ? displayRect.height : newHeight)
                        .clipped()
                        .opacity(validOpacity)
                }
                else {
                    view.opacity(0).hidden()
                }
            }
        }
    }
    
    
    fileprivate func trackRefreshableEvent(_ pullUpRect: CGRect, displayRect: CGRect, additionalScrollHeight: CGFloat = 0) {

        if (stopRefresh == false){
            let newY = pullUpRect.minY
            
            let notifyAtHeight = displayRect.height + additionalScrollHeight
            
            if(newY + notifyAtHeight < displayRect.minY){
                let newHeight = displayRect.minY - newY
                
                if(newHeight > notifyAtHeight){
                    if (enableCallback){
                        let _ = DispatchQueue.main.async {
                            pageLoadingDetector.send(true)
                        }
                    }
                }
            }
            else {
                if (!enableCallback){
                    let _ = DispatchQueue.main.async {
                        enableCallback = true
                    }
                }
            }
        }
    }
    fileprivate func stopRefreshing(continue allowMore : Bool = true){
        self.stopRefresh = true
        self.isActive = allowMore
        self.isPageLoading = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.stopRefresh = false
        })
    }
}

