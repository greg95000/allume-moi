//
//  Allume_moiApp.swift
//  Allume moi
//
//  Created by baboulinet on 11/04/2023.
//

import SwiftUI

extension Date {
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

struct UserId: EnvironmentKey {
    static var defaultValue: Int64 = Date().millisecondsSince1970 + Int64.random(in: 0...1000) + 1
}

struct DarkPurpleColor: EnvironmentKey {
    static var defaultValue = Color(red: 56 / 255, green: 0 / 255, blue: 80 / 255)
}

struct LightPurpleColor: EnvironmentKey {
    static var defaultValue = Color(red: 110 / 255, green: 51 / 255, blue: 136 / 255)
}

extension EnvironmentValues {
    var userId : Int64 {
        get { self[UserId.self] }
        set {self[UserId.self] = Date().millisecondsSince1970 + Int64.random(in: 0...1000) + 1}
    }
    
    var darkPurpleColor: Color {
        get {self[DarkPurpleColor.self]}
    }
    
    var lightPurpleColor: Color {
        get {self[LightPurpleColor.self]}
    }
}

@main
struct Allume_moiApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
