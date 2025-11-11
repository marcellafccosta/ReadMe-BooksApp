//
//  SplashScreen.swift
//  BooksApp
//
//  Created by 2213dtidigital on 16/06/25.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        Image("books")
            .resizable()
            .scaledToFit()
            .aspectRatio(contentMode: .fit)
    }
}

#Preview {
    SplashScreen()
}
