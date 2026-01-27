//
//  LayerPickerView.swift
//  PixelApp
//
//  Created by Logan on 5/5/25.
//

import SwiftUI
import UIKit

struct LayerListView: View {
    @Binding var layers: [Layer]
    @Binding var currentLayerIndex: Int
    
    let height = UIViewController().view.frame.height / 3
    let width = UIViewController().view.frame.width / 3
    
    var addLayer: () -> Void
    var deleteLayer: (_ index: Int) -> Void
    var toggleHideLayer: (_ index: Int) -> Void
    var toggleLockLayer: (_ index: Int) -> Void
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.5)) // when selected
                HStack {
                    Button(action: {
                        addLayer()
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
                ForEach(layers.indices, id: \.self) { index in
                    let layer = layers[index]
                    Button(action: {
                        currentLayerIndex = index
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(currentLayerIndex == index ? Color.blue.opacity(0.5) : Color.gray.opacity(0.5))
                            
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
                                
                                // Layer Hide
                                Button(action: {
                                    toggleHideLayer(index)
                                }) {
                                    Image(systemName: layer.hidden ? "eye.slash" :"eye")
                                }
                                
                                // Layer Lock
                                Button(action: {
                                    toggleLockLayer(index)
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
                            deleteLayer(index)
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

struct LayerPickerPanel: View {
    @Binding var layers: [Layer]
    @Binding var currentLayerIndex: Int
    
    @State private var dragAmount: CGSize = .zero
    @State private var currentDragAmount: CGSize = .zero
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
            
            VStack(spacing: 20) {
                LayerListView(
                    layers: $layers,
                    currentLayerIndex: $currentLayerIndex,
                    addLayer: {
                        layers.append(Layer(name: "Layer \(layers.count + 1)", height: layers.first?.height ?? 1, width: layers.first?.width ?? 1))
                        currentLayerIndex = max(0, layers.count - 1)
                    },
                    deleteLayer: { index in
                        guard layers.count > 1 else { return }
                        layers.remove(at: index)
                        currentLayerIndex = min(currentLayerIndex, layers.count - 1)
                    },
                    toggleHideLayer: { index in
                        layers[index].hidden.toggle()
                    },
                    toggleLockLayer: { index in
                        layers[index].locked.toggle()
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
    @State var currentLayerIndex: Int = 0
    
    var body: some View {
        LayerPickerPanel(layers: $previewLayers, currentLayerIndex: $currentLayerIndex)
    }
}

#Preview {
    PreviewLayerPicker()
}
