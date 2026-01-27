//
//  CanvasScreen.swift
//  PixelApp
//
//  Created by Logan on 4/30/25.
//

import SwiftUI

struct CanvasScreen: View {
    @StateObject private var controller = DrawingController(width: 16, height: 16)
    
    @State private var isBrushPickerVisible = false
    @State private var isColorPickerVisible = false
    @State private var isLayerPickerVisible = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // MARK: Toolbar
            AppToolbar(
                title: "Drawing",
                navigationAction: {
                    dismiss()
                },
                rightButtons: [
                    ("paintbrush.pointed.fill", {
                        isBrushPickerVisible.toggle()
                    }),
                    ("swatchpalette.fill", {
                        isColorPickerVisible.toggle()
                    }),
                    ("square.2.layers.3d.fill", {
                        isLayerPickerVisible.toggle()
                    })
                ]
            )
            .padding(.top, 2)
            
            ZStack {
                
                // MARK: Main drawing canvas
                PixelCanvasView(
                    currentLayer: $controller.drawing.layers[controller.currentLayerIndex],
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
                        VerticalSlider(value: $controller.currentOpacity)
                        VerticalSlider(value: $controller.currentBrushSize)
                    }
                    .padding(20)
                    .frame(height: UIScreen.main.bounds.height / 2)
                    
                    Spacer()
                }
                
                // MARK: Toggleable brush picker
                if isBrushPickerVisible {
                    BrushPickerPanel()
                }
                
                // MARK: Toggleable color picker
                
                if isColorPickerVisible {
                    ColorPickerPanel(
                        setCurrentColor: { color in
                            controller.setCurrentColor(color: color)
                        }
                    )
                }
                
                // MARK: Toggleable layer picker
                if isLayerPickerVisible {
                    LayerPickerPanel(
                        layers: $controller.drawing.layers,
                        currentLayerIndex: $controller.currentLayerIndex
                    )
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
    CanvasScreen()
}
