//
//  CanvasViewMain.swift
//  PixelApp
//
//  Created by Logan on 4/30/25.
//

import SwiftUI

struct CanvasViewMain: View {
    @StateObject var controller = Controller(width: 16, height: 16)
    
    @State var toggleBrushPicker: Bool = false
    @State var toggleColorPicker: Bool = false
    @State var toggleLayerPicker: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // MARK: Toolbar
            Toolbar(
                title: "Drawing",
                navigationAction: {
                    dismiss()
                },
                rightButtons: [
                    ("paintbrush.pointed.fill", {
                        print("Brush picker button clicked!")
                        toggleBrushPicker.toggle()
                    }),
                    ("swatchpalette.fill", {
                        print("Color picker button clicked!")
                        toggleColorPicker.toggle()
                    }),
                    ("square.2.layers.3d.fill", {
                        print("Layer picker button clicked!")
                        toggleLayerPicker.toggle()
                    })
                ]
            )
            .padding(.top, 2)
            
            ZStack {
                
                // MARK: Main drawing canvas
                DrawingCanvasView(
                    currentLayer: $controller.drawing.layers[controller.currentLayer],
                    currentColor: $controller.currentColor,
                    drawPixel: { row, column in
                        controller.drawPixel(row: row, column: column)
                    },
                    erasePixel: { row, column in
                        controller.erasePixel(row: row, column: column)
                    }
                )
                
                // MARK: Opacity and brush size sliders
                HStack(spacing: 0) {
                    VStack(spacing: 50) {
                        VerticleSlider(value: $controller.currentOpacity)
                        VerticleSlider(value: $controller.currentBrushSize)
                    }
                    .padding(20)
                    .frame(height: UIScreen.main.bounds.height / 2)
                    
                    Spacer()
                }
                
                // MARK: Toggleable brush picker
                if toggleBrushPicker {
                    DraggableBrushPicker()
                }
                
                // MARK: Toggleable color picker
                
                if toggleColorPicker {
                    DraggableColorPicker(
                        setCurrentColor: {color in
                            controller.setCurrentColor(color: color)
                        }
                    )
                }
                
                // MARK: Toggleable layer picker
                if toggleLayerPicker {
                    DraggableLayerPicker(layers: $controller.drawing.layers, currentLayer: $controller.currentLayer)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(.white)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CanvasViewMain()
}
