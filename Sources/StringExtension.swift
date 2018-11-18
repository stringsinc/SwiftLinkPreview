//
//  StringExtension.swift
//  SwiftLinkPreview
//
//  Created by Leonardo Cardoso on 09/06/2016.
//  Copyright © 2016 leocardz.com. All rights reserved.
//
import Foundation

#if os(iOS) || os(watchOS) || os(tvOS)
    
    import UIKit
    
#elseif os(OSX)
    
    import Cocoa
    
#endif

extension String {
    
    // Trim
    var trim: String {
        
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
    }
    
    // Remove extra white spaces
    var extendedTrim: String {
        
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ").trim
        
    }
    
    // Decode HTML entities
    var decoded: String {
        
        let encodedData = self.data(using: String.Encoding.utf8)!
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey: Any] =
            [
                NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html as Any,
                NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue as Any
        ]

        // stringsinc: All calls from Strings app to this code occur in a Promise.
        // The NSAttributedString init with html doc type needs to be on the main thread.
        // Since all code paths from Strings app to this code occur in a Promise it's
        // okay to kick this work to the main queue, if in the future this code is called
        // on the main queue a deadlock will occur.
        var result = self

        DispatchQueue.main.sync {
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                result = attributedString.string
            } catch _ {
                result = self
            }
        }

        return result
        
    }
    
    // Strip tags
    var tagsStripped: String {
        
        return self.deleteTagByPattern(Regex.rawTagPattern)
        
    }
    
    // Delete tab by pattern
    func deleteTagByPattern(_ pattern: String) -> String {
        
        return self.replacingOccurrences(of: pattern, with: "", options: .regularExpression, range: nil)
        
    }
    
    // Replace
    func replace(_ search: String, with: String) -> String {
        
        let replaced: String = self.replacingOccurrences(of: search, with: with)
        
        return replaced.isEmpty ? self : replaced
        
    }
    
    // Substring
    func substring(_ start: Int, end: Int) -> String {
        let range = self.index(self.startIndex, offsetBy: start) ..< self.index(self.startIndex, offsetBy: end)
        return String(self[range])
    }

    func substring(_ range: NSRange) -> String {
        
        var end = range.location + range.length
        end = end > self.count ? self.count - 1 : end
        
        return self.substring(range.location, end: end)
        
    }
    
    // Check if it's a valid url
    func isValidURL() -> Bool {
        
        return Regex.test(self, regex: Regex.rawUrlPattern)
        
    }
    
    // Check if url is an image
    func isImage() -> Bool {
        
        return Regex.test(self, regex: Regex.imagePattern)
        
    }
    
}

import MobileCoreServices

extension String {

	func tag(withClass: CFString) -> String? {
        return UTTypeCopyPreferredTagWithClass(withClass, self as CFString)?.takeRetainedValue() as String?
	}
	
	func uti(withClass: CFString) -> String? {
		return UTTypeCreatePreferredIdentifierForTag(withClass, self as CFString, nil)?.takeRetainedValue() as String?
	}
	
	var utiMimeType: String? {
		return tag(withClass: kUTTagClassMIMEType)
	}
	
	var utiFileExtension: String? {
		return tag(withClass: kUTTagClassFilenameExtension)
	}
	
	var mimeTypeUTI: String? {
		return uti(withClass: kUTTagClassMIMEType)
	}

	var fileExtensionUTI: String? {
		return uti(withClass: kUTTagClassFilenameExtension)
	}
	
	func utiConforms(to: String) -> Bool {
		return UTTypeConformsTo(self as CFString, to as CFString)
	}
}

