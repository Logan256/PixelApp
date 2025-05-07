//
//  LayerPicker.swift
//  PixelApp
//
//  Created by Logan on 5/5/25.
//

import SwiftUI

// TODO: Fix this to be better!
struct LayerPicker: View {
    @Binding var layers: [Layer]
    @Binding var currentLayer: Int
    
    var body: some View {
        ScrollView {
            ForEach(layers) { layer in
                Button(action: {
                    // callback to controller
                    
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray)
                        
                        HStack(spacing: 8) {
                            
                            // Brush Icon
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Text("Hello") // Replace with a preview image or shape
                                        .font(.largeTitle)
                                )
                            
                            Spacer()
                            
                            // Brush Name
                            Text(layer.name)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                        .padding() // Selected Brush Indicator
                        //                    .background(selectedBrush?.id == brush.id ? Color.blue.opacity(0.2) : Color.clear) When selected
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
}

struct DraggableLayerPicker: View {
    @Binding var layers: [Layer]
    @Binding var currentLayer: Int
    
    @State private var dragAmount: CGSize = .zero
    @State private var currentDragAmount: CGSize = .zero
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
            
            VStack(spacing: 20) {
                LayerPicker(layers: $layers, currentLayer: $currentLayer)
                
                Image(systemName: "line.3.horizontal")
                    .font(.title)
            }
        }
        .offset(
            x: dragAmount.width + currentDragAmount.width,
            y: dragAmount.height + currentDragAmount.height
        )
        .gesture(
            DragGesture()
                .onChanged { value in
                    currentDragAmount = value.translation
                }
                .onEnded { value in
                    dragAmount.width += value.translation.width
                    dragAmount.height += value.translation.height
                    currentDragAmount = .zero
                }
        )
    }
}

struct PreviewLayerPicker: View {
    
    @State var previewLayers: [Layer] = [
        Layer(name: "Layer 1", height: 8, width: 8),
        Layer(name: "Layer 2", height: 8, width: 8),
        Layer(name: "Layer 3", height: 8, width: 8)
    ]
    @State var currentLayer: Int = 0
    
    var body: some View {
        DraggableLayerPicker(layers: $previewLayers, currentLayer: $currentLayer)
    }
}

#Preview {
    PreviewLayerPicker()
}
