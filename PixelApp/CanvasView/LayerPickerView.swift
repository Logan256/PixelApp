//
//  LayerPicker.swift
//  PixelApp
//
//  Created by Logan on 5/5/25.
//

import SwiftUI

// TODO: Fix this to be better!
struct LayerPicker: View {
    @Binding var layers: [Layer] // taken from controller
    @Binding var currentLayer: Layer // taken from controller
    // frame size and stuff:
    
    let height = UIViewController().view.frame.height / 3
    let width = UIViewController().view.frame.width / 3
    
    // Layer operations
    var selectLayer: (Int) -> Void
    var deleteLayer: (Int) -> Void
    var addLayer: (Int) -> Void // add above current layer
    
    // Layer Button Actions
    var toggleHideLayer: (Layer) -> Void
    var toggleLockLayer: (Layer) -> Void
    var toggleLayerMenu: (Layer) -> Void
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.5)) // when selected
                HStack {
                    
                    
                    Button(action: {
                        // add new layer above current layer
                    }) {
                        Image(systemName: "plus")
                    }
                    
                    Spacer()

                    Text("Layers")
                }
                .padding(.horizontal)
                
            }
            .frame(width: width, height: 40)
            
            ScrollView {
                ForEach(layers) { layer in
                    Button(action: {
                        // callback to controller to open associated file
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(currentLayer == layer ? Color.blue.opacity(0.5) : Color.gray.opacity(0.5)) // when selected
                            
                            HStack(spacing: 8) {
                                
                                // Thumbnail Icon
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Text("Hello") // Replace with a preview image or shape
                                            .font(.largeTitle)
                                    )
                                
                                // Layer Name
                                Text(layer.name)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                // Layer Menu
                                Button(action: {
                                    toggleLayerMenu(layer)
                                }) {
                                    Image(systemName: "filemenu.and.selection")
                                }
                                
                                // Layer Hide
                                Button(action: {
                                    toggleHideLayer(layer)
                                }) {
                                    Image(systemName: layer.hidden ? "eye.slash" :"eye")
                                }
                                
                                // Layer Lock
                                Button(action: {
                                    toggleLockLayer(layer)
                                }) {
                                    Image(systemName: layer.locked ? "lock" : "lock.open")
                                }
                                
                                
                            }
                            .padding()
                            .cornerRadius(12)
                        }
                    }
                    // MARK: probably to delete the layer
                    .swipeActions { // swipe action
                        Button(role: .destructive) {
                            if let index = layers.firstIndex(of: layer) {
                                layers.remove(at: index)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    // MARK: optional long press for menu
//                    .gesture(
//                        LongPressGesture(minimumDuration: 2)
//                            .updating(self.$currentLayer) { value, state in
//                                // pull up layer options menu
//                            }
//                            .onEnded { finished in
//                                // pull up
//                            }
//                    )
                }
            }
            
            HStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
            }
            .frame(height: 30)
        }
        .frame(width: width, height: height)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 20))
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
                LayerPicker(
                    layers: $layers,
                    currentLayer: $layers[currentLayer],
                    selectLayer: { _ in
                        // select current layer
                    },
                    deleteLayer: { _ in
                        // select current layer
                    },
                    addLayer: { _ in
                        // select current layer
                    },
                    toggleHideLayer: { _ in
                        
                    },
                    toggleLockLayer: { _ in
                        
                    },
                    toggleLayerMenu: { _ in
                        
                    }
                )
                
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
