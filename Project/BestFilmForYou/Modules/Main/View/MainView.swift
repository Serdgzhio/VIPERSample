//
//  MainView.swift
//  BestFilmForYou
//
//  Created by user on 19.11.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import SwiftUI
import Swinject

struct MainView: View {
  
  @EnvironmentObject var viewModel: MainViewModel
  
  var body: some View {
    ZStack {
      LinearGradient(gradient: Gradient(colors: [Color.init(#colorLiteral(red: 0.8249547592, green: 0.5403262503, blue: 0.9973048834, alpha: 1)), Color.init(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1))]), startPoint: .bottom, endPoint: .top)
        .edgesIgnoringSafeArea([.top, .bottom])
      GeometryReader { geometry in
        VStack {
          if !viewModel.redoIsHidden {
            HStack {
              Spacer()
              Group {
                Button(action: {
                  viewModel.didTapRedo()
                }) {
                  Text(viewModel.buttonTitle)
                    .padding()
                    .background(Circle().fill(LinearGradient(gradient: Gradient(colors: [.init(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)), .init(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))]), startPoint: .bottomLeading, endPoint: .topTrailing)).scaledToFill()                  .shadow(color: .black, radius: 3, x: 0, y: -2))
                    .frame(width: 100, height: 100, alignment: .center)
                    .foregroundColor(.white)
                }.buttonStyle(PlainButtonStyle())
              }
            }
          }
          Spacer()
          ZStack {
            ForEach(self.viewModel.films.reversed(), id: \.id) { film in
              if let index = self.viewModel.films.firstIndex(of: film) {
                CardView(film: film, onRemove: { film  in
                  self.viewModel.didDismissCard()
                })
                .animation(.spring())
                .frame(width: self.viewModel.getCardWidth(geometry, id: index), height: 400)
                .offset(x: 0, y: self.viewModel.getCardOffset(id: index))
              }
            }
          }.padding(.bottom, 100)
        }
      }.padding()
    }.navigationBarHidden(true)
  }
}
struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    (ApplicationLocator.shared.mainScreen.view as! UIHostingController<MainView>).rootView
  }
}
