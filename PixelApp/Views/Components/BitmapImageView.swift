//
//  BitmapImageView.swift
//  PixelApp
//
//  Created by Logan on 5/4/25.
//

import SwiftUI

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
    BitmapImageView(bitmap: .mockGrid(rows: 10, columns: 10))
        .border(.black)
        .padding()
}
