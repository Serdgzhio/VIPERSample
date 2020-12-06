//
//  CardView.swift
//  BestFilmForYou
//
//  Created by user on 19.11.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import SwiftUI

struct CardView: View {
  
  @EnvironmentObject var viewModel: MainViewModel
  
  @State private var translation: CGSize = .zero
  
  private var film: FilmCardViewData
  private var onRemove: (_ film: FilmCardViewData) -> Void
  
  
  init(film: FilmCardViewData, onRemove: @escaping (_ film: FilmCardViewData) -> Void) {
    self.film = film
    self.onRemove = onRemove
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: self.viewModel.actionTextAlignment) {
        VStack(alignment: .leading) {
          Image(self.film.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: geometry.size.width, height: geometry.size.height * 0.75)
            .clipped()
          HStack {
            VStack(alignment: .leading, spacing: 6) {
              Text("\(self.film.title)")
                .font(.title)
                .bold()
              Text(self.film.rating)
                .font(.subheadline)
                .bold()
              Text("\(self.film.description)")
                .font(.subheadline)
                .foregroundColor(.gray)
            }
          }
          .padding(.horizontal)
        }
        if let actionText = self.viewModel.actionText, self.viewModel.films.first == self.film {
          Text(actionText)
            .font(.headline)
            .padding()
            .cornerRadius(10)
            .foregroundColor(Color(self.viewModel.actionTextColor))
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(Color(self.viewModel.actionTextColor), lineWidth: 3.0)
            ).padding(24)
        }
      }
      .padding(.bottom)
      .background(Color.white)
      .cornerRadius(10)
      .shadow(radius: 5)
      .animation(.interactiveSpring())
      .offset(x: self.translation.width, y: self.translation.height)
      .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 25), anchor: .bottom)
      .gesture(
        DragGesture()
          .onChanged { value in
            self.translation = value.translation
            self.viewModel.gestureDidMove(offset: value.translation)
          }.onEnded { value in
            self.viewModel.gestureDidEnd(offset: value.translation)
            self.translation = .zero
          }
      )
    }
  }
}

struct CardView_Previews: PreviewProvider {
  
  static var previews: some View {
    if let viewModel = (ApplicationLocator.shared.mainScreen.inputListener as? MainPresenter)?.viewInput as? MainViewModel {
      CardView(film: FilmCardViewData(id: "1111",
                                      title: "TITLETEXT", rating: "5.0", image: "default", description: "longlonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglong longlonglonglonglonglonglonglonglonglonglonglong longlonglong"), onRemove: {
                                        _ in
                                        
                                      })
        .frame(height: 400)
        .padding()
        .environmentObject(viewModel)
    }
  }
}
