//
//  SideBarView.swift
//  PixelApp
//
//  Created by Logan on 5/17/25.
//

import SwiftUI

struct CanvasSidebarView: View {
    @State var hue: CGFloat = 0.75
    @State var saturation: CGFloat = 0.75
    @State var brightness: CGFloat = 0.75
    
    @Binding var layers: [Layer]
    @Binding var currentLayerIndex: Int
    var setCurrentColor: (_ color: Color) -> Void
    
    var body: some View {
        VStack {
            // Top Bar Slide back button
            // Color Picker
            // Brush Picker
            // Layer Picker
            // Bottom Bar
            
            SaturationBrightnessPicker(
                hue: $hue,
                saturation: $saturation,
                brightness: $brightness,
                setCurrentColor: setCurrentColor
            )
            
            HueSlidersView(
                hue: $hue,
                saturation: $saturation,
                brightness: $brightness,
                setCurrentColor: setCurrentColor
            )
            
            BrushListView()
            
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
        }
    }
}

#Preview {
//    SideBarView()
}
