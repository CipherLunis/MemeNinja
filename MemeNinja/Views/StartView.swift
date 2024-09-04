//
//  ContentView.swift
//  MemeNinja
//
//  Created by Cipher Lunis on 8/23/24.
//

import SwiftUI

struct StartView: View {
    
    @State var showGame = false
    
    var body: some View {
        if !showGame {
            GeometryReader { geo in
                ZStack {
                    Image("WoodBG")
                        .resizable()
                        .ignoresSafeArea()
                    VStack {
                        Spacer()
                            .frame(height: geo.size.height/8)
                        HStack {
                            Spacer()
                            Image("TitleText")
                                .resizable()
                                .frame(width: geo.size.width/2, height: geo.size.height/2)
                            Spacer()
                        }
                        Spacer()
                    }
                    VStack {
                        Spacer()
                            .frame(height: geo.size.height/3)
                        HStack {
                            Image("Crewmate")
                                .resizable()
                                .frame(width: geo.size.width/5, height: geo.size.height/2)
                                .padding(.leading)
                                .padding(.leading)
                            Spacer()
                        }
                        Spacer()
                    }
                    VStack {
                        HStack {
                            Image("Katana")
                                .resizable()
                                .frame(width: geo.size.width/8, height: geo.size.height/2)
                                .rotationEffect(.degrees(-170.0))
                            Spacer()
                        }
                    }
                    .ignoresSafeArea()
                    VStack {
                        Spacer()
                            .frame(height: geo.size.height/3)
                        HStack {
                            Spacer()
                            Image("PickleRick")
                                .resizable()
                                .frame(width: geo.size.width/5, height: geo.size.height/2)
                        }
                        Spacer()
                    }
                    VStack {
                        Spacer()
                            .frame(height: geo.size.height/1.35)
                        Button(action: {
                            // start game
                            showGame = true
                        }, label: {
                            Text("Start")
                                .font(.system(size: 60.0)
                                    .bold())
                                .foregroundColor(.white)
                                .padding([.leading, .trailing, .top, .bottom], 10.0)
                                .background {
                                    RoundedRectangle(cornerRadius: 8.0)
                                        .fill(.black)
                                }
                        })
                        Spacer()
                    }
                }
            }
        } else {
            GameView()
        }
    }
}

struct Start_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
