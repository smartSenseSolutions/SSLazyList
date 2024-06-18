//
//  SSListPagger.swift
//  SSLazyList
//
//  Created by SmartSense Consulting Solutions Pvt. Ltd. on 17/05/24.
//

import Foundation
import SwiftUI
import Combine

///
/// `SSListCellFrameObserver` helps to observ position of cell/row in list
///
public struct SSListCellFrameObserver : ViewModifier {
        
    public let viewPositionDetector : CurrentValueSubject<CGRect, Never>
    public let viewPositionPublisher : AnyPublisher<CGRect, Never>
    
    @Binding var scrollRect : CGRect
        
    init(scrollRect:Binding<CGRect>) {
        
        let viewPositionDetector = CurrentValueSubject<CGRect, Never>(scrollRect.wrappedValue)
        self.viewPositionPublisher = viewPositionDetector
            .removeDuplicates()
            .debounce(for: .milliseconds(10), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
        self.viewPositionDetector = viewPositionDetector
        self._scrollRect = scrollRect
    }
            
    public func body(content: Content) -> some View {
        content.background(GeometryReader{ reader in
            Color.clear
            let _ = self.viewPositionDetector.send(reader.frame(in: .named("SSListPaggerNameSpace")))
        }.onReceive(self.viewPositionPublisher, perform: { rect in
            DispatchQueue.main.async {
                self.scrollRect = rect
            }
        }))
    }
}

