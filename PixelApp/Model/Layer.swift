//
//  Layer.swift
//  PixelApp
//
//  Created by Logan on 5/4/25.
//

import SwiftUI

// Access via `values[height][width]`
struct Layer: Identifiable, Codable {
    var id = UUID()
    var name: String
    var values: [[ColorData]]

    var height: Int { values.count }
    var width: Int { values.first?.count ?? 0 }
    var aspectRatio: CGFloat { CGFloat(width) / CGFloat(height) }

    init(name: String = "", height: Int, width: Int) {
        self.name = name
        self.values = Array(repeating: Array(repeating: ColorData(color: Color.clear), count: height), count: width)
    }
}

struct ColorData: Codable {
    let red: Double
    let green: Double
    let blue: Double
    let opacity: Double
    
    init(color: Color) {
        let uiColor = UIColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        red = Double(r)
        green = Double(g)
        blue = Double(b)
        opacity = Double(a)
    }

    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}

