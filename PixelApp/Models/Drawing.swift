//
//  DrawingModel.swift
//  PixelApp
//
//  Created by Logan on 4/30/25.
//

import SwiftUI

struct Drawing: Identifiable, Codable {
    var id = UUID() // primary key
    var name: String
    var layers: [Layer]
    var raster: BitmapData?
}

// Codable Bitmap information
struct BitmapData: Codable {
    let columns: Int
    let rows: Int
    let pixels: [[ColorData]]
    
    init(bitmap: Bitmap) {
        self.columns = bitmap.columns
        self.rows = bitmap.rows
        self.pixels = bitmap.values.map { $0.map{ ColorData(color: $0) } }
    }

    func toBitmap() -> Bitmap {
        let colors: [[Color]] = pixels.map { $0.map{ $0.color } }
        var bitmap = Bitmap(rows: rows, columns: columns)
        bitmap.values = colors
        return bitmap
    }
}
