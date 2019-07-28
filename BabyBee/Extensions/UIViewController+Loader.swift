import UIKit

extension UIViewController {
    static func showLoader(on viewController: UIViewController, transparent:Bool = false){
        if let keyWindow = viewController.view {
            if keyWindow.subviews.count > 1{
                let loader = keyWindow.subviews[1]
                if (loader.isKind(of: LoaderView.self)){
                    return
                }
            }
            let overlay = Bundle.main.loadNibNamed("LoaderView", owner: nil, options: nil)![0] as! LoaderView
            overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlay.frame = viewController.view.bounds
            keyWindow.addSubview(overlay)
            
        }
    }
    
    static func removeLoader(from viewController: UIViewController) {
        let keyWindow = viewController.view
        if let keyWindow = keyWindow, keyWindow.subviews.count > 1{
            keyWindow.subviews.forEach({ (loader) in
                if (loader.isKind(of: LoaderView.self)){
                    let overlay = loader as! LoaderView
                    overlay.removeFromSuperview()
                }
            })
        }
    }
}
