//
//  ContentView.swift
//  Allume moi
//
//  Created by baboulinet on 11/04/2023.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.darkPurpleColor) var darkPurpleColor
    @Environment(\.lightPurpleColor) var lightPurpleColor
    
    var body: some View {
        TabView {
            LightView()
                .tabItem {
                    Label("Lumière", systemImage: "lightbulb")
                }
            AboutView()
                .tabItem {
                    Label("A propos", systemImage: "person")
                }
        }
        .tint(colorScheme == .dark ? lightPurpleColor : darkPurpleColor)
        .onAppear() {
            UITabBar.appearance().backgroundColor = colorScheme == .dark ? .black : .white
            UITabBar.appearance().unselectedItemTintColor = .lightGray
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
