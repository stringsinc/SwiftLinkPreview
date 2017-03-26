//
//  PreviewError.swift
//  SwiftLinkPreview
//
//  Created by Leonardo Cardoso on 09/06/2016.
//  Copyright © 2016 leocardz.com. All rights reserved.
//
import Foundation

public enum PreviewError: Error, CustomStringConvertible {
  case noURLHasBeenFound(String?)
  case invalidURL(String?)
  case cannotBeOpened(String?)
  case parseError(String?)
  case tooLarge(String?)
  case invalidMimeType(String?)
	
  public var description: String {
    switch(self) {
      case .noURLHasBeenFound: return NSLocalizedString("No URL has been found", comment: "")
      case .invalidURL: return NSLocalizedString("This data is not valid URL", comment: "")
      case .cannotBeOpened: return NSLocalizedString("This URL cannot be opened", comment: "")
      case .parseError: return NSLocalizedString("An error occurred when parsing the HTML", comment: "")
      case .tooLarge: return NSLocalizedString("File is too large to preview", comment: "")
      case .invalidMimeType: return NSLocalizedString("File doesn't have a valid mime type for preview", comment: "")
    }
  }
}
