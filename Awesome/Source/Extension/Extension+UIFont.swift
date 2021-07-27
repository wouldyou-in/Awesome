import UIKit

struct AppFontName {
    static let bold = "GmarketSansTTFBold"
    static let light = "GmarketSansTTFLight"
    static let medium = "GmarketSansTTFMedium"
}

extension UIFont{
    
    @objc class func gmarketSansBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.bold, size: size)!
    }

    @objc class func gmarketSansLightFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.light, size: size)!
    }
    
    @objc class func gmarketSansMediumFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.medium, size: size)!
    }
}
