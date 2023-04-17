//
//  AboutView.swift
//  Allume moi
//
//  Created by baboulinet on 12/04/2023.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.darkPurpleColor) var darkPurpleColor
    @Environment(\.lightPurpleColor) var lightPurpleColor
    
    var body: some View {
        VStack {
            Text("Si vous souhaitez me rémunérer pour cette application vous pouvez à la place faire un geste en faisant un don pour cette association :")
                .multilineTextAlignment(.center)
                .padding(.all, 20)
            Link(destination: URL(string:"https://soutenir.la-spa.fr/b/mon-don?ns_ira_cr_arg=IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyNJLIZT7DJ7iDGL8x%2BRy3yUpIN18xqJ8pwlOnWLfHQo3lNkKvvC97YJ%2BKoFSTS4K86MEOi7my0t8JuBi5hVs9yl&cid=241&_cv=1")!) {
                Text("Faire un don")
            }
            .padding(.all, 20.0)
            .font(.system(size: 40))
            .foregroundColor(.white)
            .background(colorScheme == .dark ? darkPurpleColor : lightPurpleColor)
            .clipShape(Capsule())
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
