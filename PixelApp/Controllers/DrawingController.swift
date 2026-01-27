//
//  DrawingController.swift
//  PixelApp
//
//  Created by Logan on 4/30/25.
//

import Foundation
import SwiftUI

final class DrawingController: ObservableObject {
    @Published var canvasWidth: Int
    @Published var canvasHeight: Int
    @Published var drawing: Drawing
    
    @Published var currentColor: Color
    @Published var currentLayerIndex: Int
    @Published var currentBrushName: String
    
    @Published var currentOpacity: Double
    @Published var currentBrushSize: Double
    
    private(set) var drawingFileNames: [String]
    
    private var layer: Layer {
        get {
            drawing.layers[currentLayerIndex]
        }
        
        set {
            drawing.layers[currentLayerIndex] = newValue
        }
    }
    
    init(width: Int, height: Int) {
        self.canvasWidth = width
        self.canvasHeight = height
        let layer = Layer(name: "Layer 1", height: height, width: width)
        self.drawing = Drawing(name: "New Drawing", layers: [layer], raster: nil)
        
        self.currentColor = Color.black
        self.currentLayerIndex = 0
        self.currentBrushName = "Pixel Brush"
        self.currentOpacity = 1
        self.currentBrushSize = 1
        self.drawingFileNames = []
    }
    
    func addLayer() {
        let layer = Layer(name: "Layer \(drawing.layers.count + 1)", height: canvasHeight, width: canvasWidth)
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
    
    func loadDrawing(named filename: String) -> Drawing? {
        let url = documentsDirectory().appendingPathComponent(filename)
        
        do {
            let data = try Data(contentsOf: url)
            let drawing = try JSONDecoder().decode(Drawing.self, from: data)
            return drawing
        } catch {
            print("Failed to load: \(error)")
            return nil
        }
    }
    
    func saveDrawing(_ drawing: Drawing) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let filename = generateUniqueFilename()
        
        do {
            let data = try encoder.encode(drawing)
            let url = documentsDirectory().appendingPathComponent(filename)
            try data.write(to: url)
            print("Saved to \(url)")
        } catch {
            print("Failed to save: \(error)")
        }
    }
    
    func refreshDrawingFileNames() {
        let filename = "drawings_list.json"
        let url = documentsDirectory().appendingPathComponent(filename)
        if let data = try? Data(contentsOf: url),
           let fileNames = try? JSONDecoder().decode([String].self, from: data) {
            drawingFileNames = fileNames
        } else {
            drawingFileNames = []
        }
    }
    
    func persistDrawingFileNames() {
        let filename = "drawings_list.json"
        let url = documentsDirectory().appendingPathComponent(filename)
        
        if let data = try? JSONEncoder().encode(drawingFileNames) {
            try? data.write(to: url)
        } else {
            print("Error when saving drawings list!")
        }
    }
}

extension DrawingController {
    private func documentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func generateUniqueFilename(prefix: String = "Drawing") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd_HHmmss"
        let timestamp = dateFormatter.string(from: Date())
        return "\(prefix)_\(timestamp)"
    }
}
