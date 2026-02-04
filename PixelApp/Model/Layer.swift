//
//  Layer.swift
//  PixelApp
//
//  Created by Logan on 5/4/25.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

// Access via `values[height][width]`
struct Layer: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var values: [[ColorData]]

    var height: Int { values.count }
    var width: Int { values.first?.count ?? 0 }
    var aspectRatio: CGFloat { CGFloat(width) / CGFloat(height) }
    
    var hidden: Bool = false
    var locked: Bool = false

    init(name: String = "", height: Int, width: Int) {
        self.name = name
        self.values = Array(repeating: Array(repeating: ColorData(color: Color.clear), count: height), count: width)
    }
    
    static func == (lhs: Layer, rhs: Layer) -> Bool {
        return lhs.id == rhs.id
    }
}

struct ColorData: Codable {
    let red: Double
    let green: Double
    let blue: Double
    let opacity: Double
    
    init(color: Color) {
        #if canImport(UIKit)
        let platformColor = UIColor(color)
        #elseif canImport(AppKit)
        let platformColor = NSColor(color)
        #else
        let platformColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
        #endif
        
        #if canImport(UIKit) || canImport(AppKit)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        platformColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        red = Double(r)
        green = Double(g)
        blue = Double(b)
        opacity = Double(a)
        #else
        red = 0
        green = 0
        blue = 0
        opacity = 0
        #endif
    }

    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}
