//
//  ContentView.swift
//  BooksApp
//
//  Created by 2213dtidigital on 16/06/25.
//

import SwiftUI

struct ContentView: View {
    @State var isActive = false
    
    var body: some View {
        VStack {
            if self.isActive {
                Home()
            } else {
                SplashScreen()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
