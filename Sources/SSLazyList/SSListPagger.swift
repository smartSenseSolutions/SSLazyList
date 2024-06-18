//
//  SSListPagger.swift
//  iOS_Example
//
//  Created by Kalpesh on 11/06/24.
//

import Foundation
import SwiftUI

///
/// `SSListPagger` is a potocol for minumul functionality perfomed for pulltorefresh and loadmore view
///
public enum LoadMoreTypes : String {
    case onPullUp = "fromBottom"
    case onLastRow = "fromLastRow"
}

public protocol SSListPagger {    
    var displayView : (() -> AnyView){get}
    var loadingView : (() -> AnyView){get}
    var onTrigger : (@escaping(Bool)->())->(){get}
}

extension SSListPagger {
        
    var view : AnyView {
        displayView()
    }
    
    var refreshingView : AnyView {
        loadingView()
    }
    
    public var callback : (@escaping(Bool)->())->(){
        return onTrigger
    }
  
}

public class SSListPagerHandles : SSListPagger{
    
    public var displayView : (() -> AnyView)
    public var loadingView : (() -> AnyView)
    public var onTrigger : (@escaping(Bool)->())->()
    public init(displayView: @escaping () -> AnyView, loadingView: @escaping () -> AnyView, onTrigger: @escaping (@escaping (Bool) -> Void) -> Void) {
        self.displayView = displayView
        self.loadingView = loadingView
        self.onTrigger = onTrigger
    }
}


public class SSPullToRefresh : SSListPagerHandles {}

public class SSLoadMore : SSListPagerHandles{
    public let type: LoadMoreTypes
    public init(type: LoadMoreTypes, displayView: @escaping () -> AnyView, loadingView: @escaping () -> AnyView, onTrigger: @escaping (@escaping (Bool) -> Void) -> Void) {
        self.type = type
        super.init(displayView: displayView, loadingView: loadingView, onTrigger: onTrigger)
    }
}
