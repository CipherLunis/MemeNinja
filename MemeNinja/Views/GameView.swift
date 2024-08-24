//
//  GameView.swift
//  MemeNinja
//
//  Created by Cipher Lunis on 8/23/24.
//

import SpriteKit
import SwiftUI

struct GameView: View {
    
    @StateObject var game = GameScene(size: UIScreen.main.bounds.size)
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                SpriteView(scene: game/*, debugOptions: [.showsPhysics]*/)
                    .ignoresSafeArea()
                // shadow opacity
                Rectangle()
                    .fill(.black)
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .opacity(game.isGameOver ? 0.5 : 0.0)
                GameOverView(score: game.points)
                    .offset(y: game.isGameOver ? 0.0 : geo.size.height)
                    .animation(.interpolatingSpring(mass: 0.01, stiffness: 1, damping: 0.5, initialVelocity: 5.0), value: game.isGameOver)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: GameScene(size: .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
