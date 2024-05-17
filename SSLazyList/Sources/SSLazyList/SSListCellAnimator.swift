//
//  SSCellAnimationType.swift
//  SSLazyList
//
//  Created by Kalpesh on 17/05/24.
//

import Foundation
import SwiftUI

/// An enumeration representing the type of animation for new cells in a list.
public enum SSCellAnimationType : Equatable, CustomStringConvertible {
    
    // MARK: - Enum Cases
    /// No animation / Not applicable
    case none
    
    /// Animate cell type based on user interactions in all directions
    case auto(Animation, Times)
    
    /// Animate cell type top
    case fromTop(Animation, Times)
    
    /// Animate cell type bottom
    case fromBottom(Animation, Times)
    
    /// Animate cell type right
    case fromRight(Animation)
    
    /// Animate cell type left
    case fromLeft(Animation)
    
    // MARK: - Equatable Times
    /// An enumeration representing the animation timing.
    public enum Times {
        case always
        case once
    }
    
    // MARK: - Properties
    /// The timing for the animation.
    var times : Times {
        switch self{
            case .none: return .once
        case .auto(_, let value): return value
            case .fromTop(_, let value): return value
            case .fromBottom(_, let value): return value
            case .fromRight(_): return .once
            case .fromLeft(_): return .once
        }
    }
    
    /// The animation configuration.
    var animation : Animation {
        switch self{
        case .none: return .smooth(duration: 0.5)
            case .auto(let animation, _): return animation
            case .fromTop(let animation, _): return animation
            case .fromBottom(let animation, _): return animation
            case .fromRight(let animation): return animation
            case .fromLeft(let animation): return animation
        }
    }
    // MARK: - CustomStringConvertible
    /// The description for the enum
    public var description: String {
        switch self {
        case .none:
            "none"
        case .auto(_, _):
            "auto"
        case .fromTop(_, _):
            "fromTop"
        case .fromBottom(_, _):
            "fromBottom"
        case .fromRight(_):
            "fromRight"
        case .fromLeft(_):
            "fromLeft"
        }
    }
    
    // MARK: - Equatable Enum
    /// An enumeration that conforms to Equatable for comparison in applications.
    ///
    /// This enum allows instances to be compared for equality using the Equatable protocol.
    /// It defines how instances of SSCellAnimationType are compared.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.description == rhs.description
    }
}

/// A protocol that defines the behavior of view modifiers.
///
/// SSListCellAnimator conforming to `ViewModifier`  used to modify the appearance or behavior of views in SwiftUI.
/// They encapsulate a set of view transformations or customizations that can be applied to any SwiftUI view.
///
public struct SSListCellAnimator : ViewModifier {
    
    /// An enumeration representing the direction of scrolling.
    public enum ScrollDirection {
        /// Indicates no scrolling direction.
        case none
        /// Indicates scrolling to the top.
        case top
        /// Indicates scrolling to the bottom.
        case bottom
    }

    /// The type of animation for new cells.
    let newCellAnimationType : SSCellAnimationType
    
    /// The current direction of scrolling.
    @State private var scrollDirection: ScrollDirection = .bottom
    
    /// The current direction of scrolling.
    @State private var animationDistance: Double = 700

    /// A flag indicating whether the view is visible.
    @State private var isVisible : Bool = false
    
    /// The current scroll position in the view.
    ///
    /// This property stores the current scroll position as a CGPoint value.
    ///
    /// It is updating scrollDirection if it's not equal to direction
    @State var scrollPosition: CGPoint {
        didSet{
            if oldValue.y < scrollPosition.y{
                if (scrollDirection != .bottom){
                    scrollDirection = .bottom
                }
            }else{
                if (scrollDirection != .top){
                    scrollDirection = .top
                }
            }
        }
    }
    
    /// A preference key type for storing the scroll offset in SwiftUI views.
    ///
    /// This struct defines a preference key type used to store the scroll offset value,
    /// allowing SwiftUI views to communicate the current scroll position.
    struct ScrollOffsetPreferenceKey: PreferenceKey {
        static var defaultValue: CGPoint = .zero
        
        static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
            //print("scroll value ===>  %f", value)
        }
    }
    
    public func body(content: Content) -> some View {
        return content
            .opacity(isVisible ? 1.0 : 0)
            //.background(.clear)//TODO: - Test
            .coordinateSpace(name: "scroll")
            .background(GeometryReader { geometry in
                Color.clear
                    .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
            })
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                self.scrollPosition = value
            }
            .offset(calculateOffsetForAnimation(animationType: newCellAnimationType, direction: scrollDirection, animateFrom: animationDistance))
            .animation(newCellAnimationType.animation) //animation(_:value:) is not working.
            .onAppear{
                isVisible = true
            }
            .onDisappear{
                if(newCellAnimationType.times == .always){
                    isVisible = false
                }
            }
    }
    
    
    /// Calculates the offset for an animation based on the given animation type and scroll direction.
    ///
    /// This function computes the offset value to be used in an animation,
    /// considering the specified animation type and scroll direction.
    ///
    /// - Parameters:
    ///   - animationType: The type of animation for new cells.
    ///   - direction: The direction of the scroll.
    /// - Returns: The calculated offset for the animation.
    func calculateOffsetForAnimation(animationType: SSCellAnimationType, direction : ScrollDirection, animateFrom:Double)->CGSize {
        if (isVisible){
            return .zero
        }
        
        switch (animationType , direction) {
            
        case (.fromTop, .none):
            return CGSize(width: 0, height:  -1 * animateFrom)
        case (.fromBottom, .none):
            return CGSize(width: 0, height:  animateFrom)
            
        case (_, .none):
            return CGSize.zero
        case (.none, _):
            return CGSize.zero
            
        case (.auto, .bottom):
            fallthrough
        case (.fromBottom, .bottom):
            return CGSize(width: 0, height:  animateFrom)
            
        case (.auto, .top):
            fallthrough
        case (.fromTop, .top):
            return CGSize(width: 0, height:  -1 * animateFrom)
            
        case (.fromTop, .bottom):
            fallthrough
        case (.fromBottom, .top):
            return CGSize.zero
            
        case (.fromRight, .top):
            return CGSize(width:  0, height: 0)
        case (.fromRight, .bottom):
            return CGSize(width:  animateFrom, height: 0)
        case (.fromLeft, .top):
            return CGSize(width:  0, height: 0)
        case (.fromLeft, .bottom):
            return CGSize(width:  -1 * animateFrom, height: 0)
        }
    }
}
