//
//  Bitmap.swift
//  PixelApp
//
//  Created by Logan on 5/4/25.
//

import SwiftUI

struct Bitmap: Equatable, Sendable {
    // Access via `values[row][column]`
    var values: [[Color]]

    var rows: Int { values.count }
    var columns: Int { values.first?.count ?? 0 }
    var aspectRatio: CGFloat { CGFloat(columns) / CGFloat(rows) }
}

extension Bitmap {
    init(_ initialColor: Color? = nil, rows: Int, columns: Int) {
        values = .init(repeating: .init(repeating: initialColor ?? .white, count: columns), count: rows)
    }

    mutating func fill(_ color: Color) {
        values = .init(repeating: .init(repeating: color, count: columns), count: rows)
    }

    static func mockGrid(rows: Int, columns: Int) -> Self {
        var instance = Self(rows: rows, columns: columns)
        for row in 0 ..< rows {
            for column in 0 ..< columns {
                instance.values[row][column] = row % 2 == column % 2 ? .black : .white
            }
        }
        return instance
    }

    static func mockRowColors(rows: Int, columns: Int) -> Self {
        var instance = Self(rows: rows, columns: columns)
        for row in 0 ..< rows {
            instance.values[row] = Array(repeating: .init(hue: Double(row) / Double(rows), saturation: 0.7, brightness: 1.0), count: columns)
        }
        return instance
    }
}
