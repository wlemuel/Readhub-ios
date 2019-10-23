//
//  UIImageExtension.swift
//  readhub
//
//  Created by Steve Lemuel on 10/15/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

#if os(iOS) || os(tvOS)

    import UIKit

    extension UIImage {
        /// EZSE: scales image
        public class func scaleTo(image: UIImage, w: CGFloat, h: CGFloat) -> UIImage {
            let newSize = CGSize(width: w, height: h)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return newImage
        }

        /// EZSE Returns resized image with width. Might return low quality
        public func resizeWithWidth(_ width: CGFloat) -> UIImage {
            let aspectSize = CGSize(width: width, height: aspectHeightForWidth(width))

            UIGraphicsBeginImageContext(aspectSize)
            draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return img!
        }

        /// EZSE Returns resized image with height. Might return low quality
        public func resizeWithHeight(_ height: CGFloat) -> UIImage {
            let aspectSize = CGSize(width: aspectWidthForHeight(height), height: height)

            UIGraphicsBeginImageContext(aspectSize)
            draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return img!
        }

        /// EZSE:
        public func aspectHeightForWidth(_ width: CGFloat) -> CGFloat {
            return (width * size.height) / size.width
        }

        /// EZSE:
        public func aspectWidthForHeight(_ height: CGFloat) -> CGFloat {
            return (height * size.width) / size.height
        }

        /// EZSE: Returns cropped image from CGRect
        public func croppedImage(_ bound: CGRect) -> UIImage? {
            guard size.width > bound.origin.x else {
                print("EZSE: Your cropping X coordinate is larger than the image width")
                return nil
            }
            guard size.height > bound.origin.y else {
                print("EZSE: Your cropping Y coordinate is larger than the image height")
                return nil
            }
            let scaledBounds: CGRect = CGRect(x: bound.origin.x * scale, y: bound.origin.y * scale, width: bound.width * scale, height: bound.height * scale)
            let imageRef = cgImage?.cropping(to: scaledBounds)
            let croppedImage: UIImage = UIImage(cgImage: imageRef!, scale: scale, orientation: UIImage.Orientation.up)
            return croppedImage
        }

        /// EZSE: Use current image for pattern of color
        public func withColor(_ tintColor: UIColor) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)

            let context = UIGraphicsGetCurrentContext()
            context?.translateBy(x: 0, y: size.height)
            context?.scaleBy(x: 1.0, y: -1.0)
            context?.setBlendMode(CGBlendMode.normal)

            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height) as CGRect
            context?.clip(to: rect, mask: cgImage!)
            tintColor.setFill()
            context?.fill(rect)

            let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
            UIGraphicsEndImageContext()

            return newImage
        }

        /// EZSE: Returns the image associated with the URL
        public convenience init?(urlString: String) {
            guard let url = URL(string: urlString) else {
                self.init(data: Data())
                return
            }
            guard let data = try? Data(contentsOf: url) else {
                print("EZSE: No image in URL \(urlString)")
                self.init(data: Data())
                return
            }
            self.init(data: data)
        }

        /// EZSE: Returns an empty image //TODO: Add to readme
        public class func blankImage() -> UIImage {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0.0)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!
        }
    }

#endif
