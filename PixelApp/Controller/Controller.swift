//
//  Controller.swift
//  PixelApp
//
//  Created by Logan on 4/30/25.
//

import Foundation
import SwiftUI

class Controller: ObservableObject {
    @Published var width: Int
    @Published var height: Int
    @Published var drawing: Drawing
    
    @Published var currentColor: Color
    @Published var currentLayer: Int
    @Published var currentBrush: String
    
    @Published var currentOpacity: Double
    @Published var currentBrushSize: Double
    
    private var layer: Layer {
        get {
            drawing.layers[currentLayer]
        }
        
        set {
            drawing.layers[currentLayer] = newValue
        }
    }
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        let layer = Layer(name: "Layer 1", height: height, width: width)
        self.drawing = Drawing.init(name: "New Drawing", layers: [layer], raster: nil)
        
        self.currentColor = Color.black
        self.currentLayer = 0
        self.currentBrush = ""
        self.currentOpacity = 1
        self.currentBrushSize = 1
    }
    
    func addLayer() {
        let layer = Layer(name: "Layer \(drawing.layers.count)", height: height, width: width)
        self.drawing.layers.append(layer)
    }
    
    // column = width, row = height
    func drawPixel(row: Int, column: Int) {
        self.layer.values[row][column] = ColorData(color: currentColor)
    }
    
    func erasePixel(row: Int, column: Int) {
        self.layer.values[row][column] = ColorData(color: Color.clear)
    }
    
    func setCurrentColor(color: Color) {
        self.currentColor = color
    }
    
    func getBrushes(set: String) {
        // brushes can be organized into sets and it gets that set
    }
    
    func loadDrawing() {
        
    }
    
    func saveDrawing() {
        
    }
}
