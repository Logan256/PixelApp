//
//  BitmapTest.swift
//  PixelApp
//
//  Created by Logan on 5/4/25.
//

import SwiftUI

// use this for bitmap conversions

// bitmap colors
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

struct BitmapImageView: View {
    let bitmap: Bitmap

    var body: some View {
        Image(
            size: .init(width: bitmap.columns, height: bitmap.rows),
            label: nil,
            opaque: true,
            colorMode: .nonLinear
        ) { ctx in
            let cellWidth: CGFloat = 1
            let cellHeight: CGFloat = 1
            for row in 0 ..< bitmap.rows {
                for column in 0 ..< bitmap.columns {
                    let path = Path(
                        CGRect(
                            x: CGFloat(column) * cellWidth,
                            y: CGFloat(row) * cellHeight,
                            width: cellWidth,
                            height: cellHeight
                        )
                    )
                    ctx.fill(path, with: .color(bitmap.values[row][column]))
                }
            }
        }
        .interpolation(.none)
        .resizable()
        .scaledToFit()
    }
}

#Preview {
    BitmapImageView(bitmap: .mockGrid(rows: 10, columns: 10))        .border(.black)
        .padding()
}
