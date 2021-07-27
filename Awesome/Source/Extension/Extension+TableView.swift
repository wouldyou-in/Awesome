
import UIKit

extension UITableView {
    
    public func registerCustomXib(xibName: String){
        let xib = UINib(nibName: xibName, bundle: nil)
        self.register(xib, forCellReuseIdentifier: xibName)
    }
    
//    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
//        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
//            fatalError("Unable Dequeue Reusable")
//        }
//        return cell
//    }
    
}
