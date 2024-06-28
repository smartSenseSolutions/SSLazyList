//
//  SSListRefresher.swift
//  SSLazyList
//
//  Created by SmartSense Consulting Solutions Pvt. Ltd. on 17/05/24.
//

import Foundation
import SwiftUI
import Combine

///
/// `SSListRefresher` adds refreshview and observes position and triggers action at certain point of position
///
public struct SSListRefresher : ViewModifier {
    
    let refreshDetector: PassthroughSubject<Bool, Never>
    public let refreshPublisher: AnyPublisher<Bool, Never>
    
    private var onRefresh : ((@escaping(Bool)->())->())? = nil
    @State var stopNotifying : Bool = false
    @Binding var isActive : Bool
    
    @Binding var pullDownRect : CGRect
    @Binding var displayRect : CGRect
        
    init(isActive:Binding<Bool>, isRefreshing:Binding<Bool>, pullDownRect : Binding<CGRect>, displayRect: Binding<CGRect>,onRefresh: @escaping ((@escaping(Bool)->())->())) {

        let refreshDetector = PassthroughSubject<Bool,Never>()
        self.refreshPublisher = refreshDetector
            .removeDuplicates()
            .debounce(for: .milliseconds(10), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
        self.refreshDetector = refreshDetector
        self.onRefresh = onRefresh
        
        self._isRefreshing = isRefreshing
        self._pullDownRect = pullDownRect
        self._displayRect = displayRect
        self._isActive = isActive
    }

    
    @State var enableCallback : Bool = true
    
    @Binding public var isRefreshing :Bool
    
    public func body(content: Content) -> some View {
        if (isActive){
            self.refresherView(view: content, pullDownRect: pullDownRect, displayRect: displayRect)
                .onReceive(self.refreshPublisher, perform: { value in
                    self.isRefreshing = true
                    self.onRefresh?(stopObserving)
                })
        }else{
            content
        }
    }
    
    
    func refresherView<Content:View>(view:Content, pullDownRect:CGRect, displayRect: CGRect)-> some View {
        Group{
            let newY = pullDownRect.minY
            let maxAllowedY = pullDownRect.height > displayRect.height ?  pullDownRect.height :  displayRect.height
            if(newY > displayRect.minY && newY < maxAllowedY * 3 ){
                let _ = trackRefreshableEvent(pullDownRect, displayRect: displayRect)
                
                let newHeight = newY - displayRect.minY
                let refOpacity = newHeight / displayRect.height
                let validOpacity = min(1, refOpacity)
                
                view
                    .frame(width: displayRect.width, height: newHeight)
                    .clipped()
                    .opacity(validOpacity)
            }
            else {
                view.opacity(0)
            }
        }
    }
    
    fileprivate func trackRefreshableEvent(_ pullDownRect: CGRect, displayRect: CGRect) {
        
        if stopNotifying == false {
            let newY = pullDownRect.minY
            
            if(newY > displayRect.minY + 8){
                let newHeight = newY - displayRect.minY
                let notifyAtHeight = displayRect.height + 20
                if(newHeight > notifyAtHeight){
                    if (enableCallback){
                        let _ = DispatchQueue.main.async {
                            if (enableCallback){
                                enableCallback.toggle()
                                refreshDetector.send(true)
                            }
                        }
                    }
                }
            }
            else {
                if (!enableCallback){
                    let _ = DispatchQueue.main.async {
                        if (!enableCallback){
                            enableCallback.toggle()
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func stopObserving(continue allowMore : Bool = true){
        
        self.stopNotifying = true
        self.isActive = allowMore
        self.isRefreshing = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.stopNotifying = false
        })
    }
}

