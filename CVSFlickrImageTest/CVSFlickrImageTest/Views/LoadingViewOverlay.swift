//
//  LoadingViewOverlay.swift
//  CVSFlickrImageTest
//
//  Created by Joseph Nash on 11/19/24.
//

import SwiftUI

struct LoadingViewOverlay: ViewModifier {
  @Binding var isShowing: Bool
  func body(content: Content) -> some View {
    content
      .overlay(Group {
        if isShowing {
          ProgressView().progressViewStyle(.circular)
        }
      })
    }
}
