//
//  GameOverView.swift
//  MemeNinja
//
//  Created by Cipher Lunis on 8/24/24.
//

import SwiftUI

struct GameOverView: View {
    
    var score: Int
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("Game Over!")
                    .font(.system(size: 60.0))
                    .bold()
                Spacer()
                    .frame(height: geo.size.height/12)
                Text("Score: \(score)")
                    .font(.system(size: 38.0))
                    .bold()
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(.brown)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(score: 20)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
