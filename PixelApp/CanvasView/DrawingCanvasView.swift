//
//  DrawingCanvasView.swift
//  PixelApp
//
//  Created by Logan on 5/5/25.
//

import SwiftUI

// TODO: make each cell scale with screensize
struct DrawingCanvasView: View {
    @State private var dragAmount: CGSize = .zero
    @State private var currentDragAmount: CGSize = .zero
    @State private var rotationAngle: Angle = .zero
    @State private var currentRotation: Angle = .zero
    @State private var scale: CGFloat = 1.0
    @State private var currentScale: CGFloat = 1.0
    
    @State private var isDragging = false
    @State private var lastTouchedCell: (row: Int, col: Int)? = nil
    let cellSize: CGFloat = 40
    
    @Binding var currentLayer: Layer
    @Binding var currentColor: Color
    let drawPixel: (_ row: Int, _ column: Int) -> Void
    let erasePixel: (_ row: Int, _ column: Int) -> Void
    
    var body: some View {
        ZStack {
//            GeometryReader { geometry in
                VStack(spacing: 0) {
                    ForEach(0..<currentLayer.height, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<currentLayer.width, id: \.self) { col in
                                Rectangle()
                                    .fill(currentLayer.values[row][col])
                                    .frame(width: cellSize, height: cellSize)
                                    .border(Color.gray)
                                    .contentShape(Rectangle()) // makes the whole cell tappable
                                    .onTapGesture {
//                                        currentLayer.values[row][col] = currentColor
                                        drawPixel(row, col)
                                    }
                            }
                        }
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            isDragging = true
                            let location = value.location
                            
                            let col = Int(location.x / cellSize)
                            let row = Int(location.y / cellSize)
                            
                            // Clamp row and col to stay within bounds
                            guard row >= 0, row < currentLayer.height,
                                  col >= 0, col < currentLayer.width else { return }
                            
                            drawPixel(row, col)
//                            currentLayer.values[row][col] = currentColor
                        }
                        .onEnded { _ in
                            isDragging = false
                            lastTouchedCell = nil
                        }
                )
//            }
        }
        .offset(x: dragAmount.width + currentDragAmount.width,
                y: dragAmount.height + currentDragAmount.height)
        .rotationEffect(rotationAngle + currentRotation)
        .scaleEffect(scale * currentScale)
        .simultaneousGesture(
            RotationGesture()
                .onChanged { angle in
                    currentRotation = angle
                }
                .onEnded { angle in
                    rotationAngle += angle
                    currentRotation = .zero
                }
        )
        .simultaneousGesture(
            MagnifyGesture()
                .onChanged { value in
                    currentScale = value.magnification
                }
                .onEnded { value in
                    scale *= currentScale
                    currentScale = 1.0
                }
        )
    }
}

func normalizeDragTranslation(drag: CGSize, angle: Angle) -> CGSize {
    let radians = -angle.radians
    let cosine = cos(radians)
    let sine = sin(radians)
    
    let normalizedWidth = drag.width * cosine - drag.height * sine
    let normalizedHeight = drag.width * sine + drag.height * cosine
    
    return CGSize(width: normalizedWidth, height: normalizedHeight)
}

struct PreviewDrawingCanvas: View {
    @State var layer: Layer
    @State var color: Color
    
    init() {
        self.layer = Layer(name: "Layer", height: 16, width: 16)
        self.color = Color.black
    }
    
    var body: some View {
        DrawingCanvasView(
            currentLayer: $layer,
            currentColor: $color,
            drawPixel: {row, column in},
            erasePixel: {row, column in}
        )
    }
}

#Preview {
    PreviewDrawingCanvas()
}
