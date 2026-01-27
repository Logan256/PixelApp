//
//  BrushPickerView.swift
//  PixelApp
//
//  Created by Logan on 5/5/25.
//

import SwiftUI

// TODO: Make a list like thing
struct BrushListView: View {
    private let brushes: [Brush] = [
        Brush(name: "Pixel Brush"),
        Brush(name: "Dimple Brush"),
        Brush(name: "Dipple Brush"),
        Brush(name: "Line Brush"),
        Brush(name: "Outline Brush"),
        Brush(name: "Big Brush"),
    ]
    
    var body: some View {
        ScrollView {
            ForEach(brushes) { brush in
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
                                    Text("🖌️") // Replace with a preview image or shape
                                        .font(.largeTitle)
                                )
                            
                            Spacer()
                            
                            // Brush Name
                            Text(brush.name)
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

struct BrushPickerPanel: View {
    @State private var dragAmount: CGSize = .zero
    @State private var currentDragAmount: CGSize = .zero
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .fill(.white)
            VStack(spacing: 20) {
                BrushListView()
                
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
                .onChanged{ value in
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

#Preview {
    BrushPickerPanel()
}
