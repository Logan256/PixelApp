//
//  SideBarView.swift
//  PixelApp
//
//  Created by Logan on 5/17/25.
//

import SwiftUI

struct SideBarView: View {
    @State var hue: CGFloat = 0.75
    @State var saturation: CGFloat = 0.75
    @State var brightness: CGFloat = 0.75
    
    @Binding var layers: [Layer]
    @Binding var currentLayer: Int
    var setCurrentColor: (_ color: Color) -> Void
    
    var body: some View {
        VStack {
            // Top Bar Slide back button
            // Color Picker
            // Brush Picker
            // Layer Picker
            // Bottom Bar
            
            ColorPicker(
                hue: $hue,
                saturation: $saturation,
                brightness: $brightness,
                setCurrentColor: setCurrentColor
            )
            
            
            BrushPicker()
            
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
                    // hide layer selected
                },
                toggleLockLayer: { _ in
                    // lock layer selected
                },
                toggleLayerMenu: { _ in
                    //
                }
            )
        }
    }
}

#Preview {
//    SideBarView()
}
