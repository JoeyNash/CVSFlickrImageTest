//
//  DateFormatter+Extensions.swift
//  CVSFlickrImageTest
//
//  Created by Joseph Nash on 11/19/24.
//

import Foundation

extension DateFormatter {
  static let displayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = .current
    formatter.dateFormat = "MMM dd, YYYY"
    return formatter
  }()
}
