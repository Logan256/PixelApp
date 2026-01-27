//
//  MainMenuView.swift
//  PixelApp
//
//  Created by Logan on 4/30/25.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Go to Canvas", value: "canvas")
            }
            .navigationTitle("Main Menu")
            .navigationDestination(for: String.self) { value in
                switch value {
                case "canvas":
                    CanvasScreen()
                default:
                    Text("Unknown")
                }
            }
        }
    }
}

#Preview {
    MainMenuView()
}
