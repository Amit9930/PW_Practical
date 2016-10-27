//
//  HeaderView.swift
//  Parallex Auto Layout Demo
//
//  Created by Rune Madsen on 2015-08-30.
//  Copyright © 2015 The App Boutique. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    var heightLayoutConstraint = NSLayoutConstraint()
    var bottomLayoutConstraint = NSLayoutConstraint()
    
    var containerView = UIView()
    var containerLayoutConstraint = NSLayoutConstraint()
    
    var DateLabel:UILabel = UILabel ()
    var HeaderLabel:UILabel = UILabel ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        // The container view is needed to extend the visible area for the image view
        // to include that below the navigation bar. If this container view isn't present
        // the image view would be clipped at the navigation bar's bottom and the parallax
        // effect would not work correctly
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white
        self.addSubview(containerView)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["containerView" : containerView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["containerView" : containerView]))
        containerLayoutConstraint = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0)
        self.addConstraint(containerLayoutConstraint)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let imageView: UIImageView = UIImageView.init()
        imageView.tag = 123
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.white
        imageView.clipsToBounds = true
        
        if appDelegate.objModelCollection.imageURL.contains("NoValue") {
            
            imageView.image = UIImage(named: "placeholder_nomoon")
        }
        else {
            imageView.image = readFile(imageName: appDelegate.objModelCollection.imageURL)
        }
        
        imageView.contentMode = .scaleAspectFill
        
        containerView.addSubview(imageView)
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["imageView" : imageView]))
        bottomLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        containerView.addConstraint(bottomLayoutConstraint)
        heightLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: containerView, attribute: .height, multiplier: 1.0, constant: 0.0)
        containerView.addConstraint(heightLayoutConstraint)
        
        // ADD DATE & HEADER LABLE (animated)
        
        DateLabel = UILabel(frame: CGRect(x: 0, y: 140, width: 320, height: 22))
        DateLabel.center = CGPoint(x: 164, y: 151)
        DateLabel.textAlignment = .left
        DateLabel.text = appDelegate.objModelCollection.date
        DateLabel.font = UIFont.systemFont(ofSize: 10)
        containerView.addSubview(DateLabel)

        HeaderLabel = UILabel(frame: CGRect(x: 0, y: 160, width: 320, height: 30))
        HeaderLabel.center = CGPoint(x: 164, y: 175)
        HeaderLabel.textAlignment = .left
        HeaderLabel.text = appDelegate.objModelCollection.title
        HeaderLabel.font = UIFont.boldSystemFont(ofSize: 22)
        containerView.addSubview(HeaderLabel)

    }
    
    func convertGradientToImage(frame: CGRect) -> UIImage {
        
        // start with a CAGradientLayer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        
        gradientLayer.colors = [ UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [ 0.0, 1.0 ]
        gradientLayer.isOpaque = false
        gradientLayer.locations = [0.0,  0.3, 0.5, 0.7, 1.0]
        
        // now build a UIImage from the gradient
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // return the gradient image
        return gradientImage!
    }
    
    func removeSpecialCharsFromString(str: String) -> String {
        let chars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890".characters)
        return String(str.characters.filter { chars.contains($0) })
    }
    
    func readFile(imageName:String) -> UIImage {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("\(removeSpecialCharsFromString(str: imageName)).jpg").path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)!
        }
        return UIImage()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        containerLayoutConstraint.constant = scrollView.contentInset.top;
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top);
        containerView.clipsToBounds = offsetY <= 0
        bottomLayoutConstraint.constant = offsetY >= 0 ? 0 : -offsetY / 2
        heightLayoutConstraint.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}
