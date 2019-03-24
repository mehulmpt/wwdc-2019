import UIKit

extension UIButton {
    public func stringTag() -> String? {
       return self.currentTitle
    }
}

public func getNextPage() -> String {
    return "\n\n[**Next Page**](@next)"
}

public func getPrevPage() -> String {
    return "\n\n[**Previous Page**](@previous)"
}