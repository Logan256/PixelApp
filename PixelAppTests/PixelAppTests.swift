//
//  PixelAppTests.swift
//  PixelAppTests
//
//  Created by Logan on 4/30/25.
//

import XCTest
import SwiftUI
@testable import PixelApp

final class PixelAppModelTests: XCTestCase {
    func testLayerInitializationUsesHeightAsRows() {
        let layer = Layer(name: "Test", height: 3, width: 5)
        
        XCTAssertEqual(layer.height, 3)
        XCTAssertEqual(layer.width, 5)
        XCTAssertEqual(layer.values.count, 3)
        XCTAssertEqual(layer.values.first?.count, 5)
    }
    
    func testBitmapDataRoundTrip() {
        var bitmap = Bitmap(rows: 2, columns: 2)
        bitmap.values[0][0] = .red
        bitmap.values[1][1] = .blue
        
        let encoded = BitmapData(bitmap: bitmap)
        let decoded = encoded.toBitmap()
        
        XCTAssertEqual(decoded.rows, bitmap.rows)
        XCTAssertEqual(decoded.columns, bitmap.columns)
        let originalRed = ColorData(color: bitmap.values[0][0])
        let roundTripRed = ColorData(color: decoded.values[0][0])
        XCTAssertEqual(roundTripRed.red, originalRed.red, accuracy: 0.01)
        XCTAssertEqual(roundTripRed.green, originalRed.green, accuracy: 0.01)
        XCTAssertEqual(roundTripRed.blue, originalRed.blue, accuracy: 0.01)
        XCTAssertEqual(roundTripRed.opacity, originalRed.opacity, accuracy: 0.01)
        
        let originalBlue = ColorData(color: bitmap.values[1][1])
        let roundTripBlue = ColorData(color: decoded.values[1][1])
        XCTAssertEqual(roundTripBlue.red, originalBlue.red, accuracy: 0.01)
        XCTAssertEqual(roundTripBlue.green, originalBlue.green, accuracy: 0.01)
        XCTAssertEqual(roundTripBlue.blue, originalBlue.blue, accuracy: 0.01)
        XCTAssertEqual(roundTripBlue.opacity, originalBlue.opacity, accuracy: 0.01)
    }
    
    func testDrawingCodableRoundTrip() throws {
        let layer = Layer(name: "Layer 1", height: 2, width: 2)
        let drawing = Drawing(name: "Test", layers: [layer], raster: nil)
        
        let data = try JSONEncoder().encode(drawing)
        let decoded = try JSONDecoder().decode(Drawing.self, from: data)
        
        XCTAssertEqual(decoded.name, drawing.name)
        XCTAssertEqual(decoded.layers.count, 1)
        XCTAssertEqual(decoded.layers[0].height, 2)
        XCTAssertEqual(decoded.layers[0].width, 2)
    }
}

final class PixelAppControllerTests: XCTestCase {
    func testDrawingControllerDrawAndErase() {
        let controller = DrawingController(width: 2, height: 2)
        controller.setCurrentColor(color: .red)
        
        controller.drawPixel(row: 0, column: 1)
        
        let drawn = controller.drawing.layers[0].values[0][1]
        let red = ColorData(color: .red)
        XCTAssertEqual(drawn.red, red.red, accuracy: 0.01)
        XCTAssertEqual(drawn.green, red.green, accuracy: 0.01)
        XCTAssertEqual(drawn.blue, red.blue, accuracy: 0.01)
        XCTAssertEqual(drawn.opacity, red.opacity, accuracy: 0.01)
        
        controller.erasePixel(row: 0, column: 1)
        let erased = controller.drawing.layers[0].values[0][1]
        let clear = ColorData(color: .clear)
        XCTAssertEqual(erased.opacity, clear.opacity, accuracy: 0.01)
    }
    
    func testDrawingControllerAddLayer() {
        let controller = DrawingController(width: 4, height: 4)
        XCTAssertEqual(controller.drawing.layers.count, 1)
        
        controller.addLayer()
        
        XCTAssertEqual(controller.drawing.layers.count, 2)
        XCTAssertEqual(controller.drawing.layers.last?.name, "Layer 2")
    }
}
