//
// Created by Imthathullah on 14/02/23.
//

import SwiftUI

public protocol ImageRepresentable {
  var value: Image { get }
  var data: Data? { get }
  var size: CGSize { get }
  func centerCropped(to targetSize: CGSize) -> UIImage
}

#if canImport(UIKit)
extension UIImage: ImageRepresentable {
  public var data: Data? { pngData() }
  public var value: Image { Image(uiImage: self) }

  public func centerCropped(to targetSize: CGSize) -> UIImage {
    guard let cgimage = self.cgImage else { return self }

    let contextImage: UIImage = UIImage(cgImage: cgimage)

    guard let newCgImage = contextImage.cgImage else { return self }

    let contextSize: CGSize = contextImage.size

    //Set to square
    var posX: CGFloat = 0.0
    var posY: CGFloat = 0.0
    let cropAspect: CGFloat = targetSize.width / targetSize.height

    var cropWidth: CGFloat = targetSize.width
    var cropHeight: CGFloat = targetSize.height

    if targetSize.width > targetSize.height { //Landscape
      cropWidth = contextSize.width
      cropHeight = contextSize.width / cropAspect
      posY = (contextSize.height - cropHeight) / 2
    } else if targetSize.width < targetSize.height { //Portrait
      cropHeight = contextSize.height
      cropWidth = contextSize.height * cropAspect
      posX = (contextSize.width - cropWidth) / 2
    } else { //Square
      if contextSize.width >= contextSize.height { //Square on landscape (or square)
        cropHeight = contextSize.height
        cropWidth = contextSize.height * cropAspect
        posX = (contextSize.width - cropWidth) / 2
      }else{ //Square on portrait
        cropWidth = contextSize.width
        cropHeight = contextSize.width / cropAspect
        posY = (contextSize.height - cropHeight) / 2
      }
    }

    let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)

    // Create bitmap image from context using the rect
    guard let imageRef: CGImage = newCgImage.cropping(to: rect) else { return self}

    // Create a new image based on the imageRef and rotate back to the original orientation
    let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

    UIGraphicsBeginImageContextWithOptions(targetSize, false, self.scale)
    cropped.draw(in: CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
    let resized = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return resized ?? self
  }
}

#elseif canImport(AppKit)
extension NSImage: ImageRepresentable {
  public var value: Image { Image(nsImage: self) }
  public var data: Data? { tiffRepresentation }
}
#endif

public extension Data {
  var imageRepresentation: ImageRepresentable? {
    #if canImport(UIKit)
    return UIImage(data: self)
    #elseif canImport(AppKit)
    return NSImage(data: self)
    #endif
  }
}

public extension String {
  var imageRepresentation: ImageRepresentable {
    #if canImport(UIKit)
    return UIImage(named: self)!
    #elseif canImport(AppKit)
    return NSImage(named: self)!
    #endif
  }
}
