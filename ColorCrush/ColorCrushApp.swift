//
//  ColorCrushApp.swift
//  ColorCrush
//
//  Created by TwentyFifth on 17/01/2025.
//

import SwiftUI

@main
struct ColorCrushApp: App {
    @StateObject private var viewmodel = GameViewModel(8, 8, 5){
        [.oval, .drop, .app, .circle, .star, .heart, .snow].randomElement()!
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewmodel)
        }
    }
}
