//
//  LightView.swift
//  Allume moi
//
//  Created by baboulinet on 12/04/2023.
//

import SwiftUI
import CoreLocation


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

struct LightView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.userId) var userId
    @Environment(\.darkPurpleColor) var darkPurpleColor
    @Environment(\.lightPurpleColor) var lightPurpleColor
    
    private let httpService =  HTTPService()
    
    
    @State private var showAlert = false
    @State private var startLocation = false
    @State private var errorMessage = ""
    @State private var showSettingAlert = false
    @ObservedObject var locationService = LocationService.shared
    
    
    var body: some View {
        Button {
            switch self.locationService.getAuthorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                self.startLocation.toggle()
                if self.startLocation {
                    self.locationService.start()
                } else {
                    self.locationService.stop()
                }
                break
            default:
                redirectToSetting()
            }
        } label: {
            VStack {
                Image(systemName: self.startLocation ? "lightbulb.fill": "lightbulb")
                    .font(.system(size: 400))
                Text(!self.startLocation ? "Activer la géolocalisation" : "Stopper la géolocalisation").font(.system(size: 30))
            }.foregroundColor(colorScheme == .light ? darkPurpleColor : lightPurpleColor)
        }
        .alert(isPresented: self.$showAlert) {
            if self.showSettingAlert {
                if let url = URL(string: UIApplication.openSettingsURLString),  UIApplication.shared.canOpenURL(url){
                    return Alert(title: Text(self.errorMessage), primaryButton: .destructive(Text("Rediriger")) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        self.showSettingAlert = false
                    },
                          secondaryButton: .cancel(Text("Annuler")))
                } else {
                    return Alert(title: Text("Une erreur inconnue est survenue"))
                }
            }
            else {
                return Alert(title: Text(self.errorMessage))
            }
        }
        .onReceive(self.locationService.$userLocation) { userLocation in
            if self.startLocation && userLocation != nil {
                callingJallume(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
            }
        }
    }
    
    func redirectToSetting(){
        self.showSettingAlert = true
        self.errorMessage = "Les permission de géolocalisation sont nécessaires pour utiliser cette fonctionnalité. Voulez-vous être redirigé vers les réglages de l'application pour les activer?"
        self.showAlert = true
    }
    
    
    
    func callingJallume(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let postData = NSData(data: "data={ \"IdUser\": \"\(userId)\" ,\"test\": \"0\", \"timestart\":  \"\(Date().millisecondsSince1970)\", \"offsetTemps\": \"-120\", \"precision\": \"10\", \"latitude\": \"\(latitude)\", \"longitude\": \"\(longitude)\"}".data(using: String.Encoding.utf8)!) as Data
        
        self.httpService.post("Tracking.php", postData) { success, data in
            if !success {
                self.showAlert = true
                self.errorMessage = "Une erreur réseau est survenue \(data)"
                return
            }
        }
    }
}

struct LightView_Previews: PreviewProvider {
    static var previews: some View {
        LightView()
    }
}
