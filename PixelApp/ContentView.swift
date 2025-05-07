//
//  ContentView.swift
//  PixelApp
//
//  Created by Logan on 4/30/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Go to Brush Picker", value: "brushPicker")
                NavigationLink("Go to Canvas", value: "canvas")
            }
            .navigationTitle("Main Menu")
            .navigationDestination(for: String.self) { value in
                switch value {
                case "brushPicker":
                    BrushPicker()
                case "canvas":
                    CanvasViewMain()
                default:
                    Text("Unknown")
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
