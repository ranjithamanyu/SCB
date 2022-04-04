//
//  Helper.swift
//  SCB
//
//  Created by Mac on 02/04/22.
//

import Foundation
import UIKit
import NVActivityIndicatorView

extension UIView {

    func roundCorners(with CACornerMask: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [CACornerMask]
    }
    
    func setBorderView(borderHeight: CGFloat, borderColor: UIColor) {
        self.layer.borderWidth = borderHeight
        self.layer.borderColor = borderColor.cgColor
    }

    class func defaultAnimation(_ success: @escaping () -> Void,
                                duration: TimeInterval = 0.3,
                                completionWithAnimation: (Bool)? = nil, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            success()
        }) { (_) in
            guard completion != nil, let innerCompletion = completion else {
                return
            }
            guard completionWithAnimation != nil else {
                completion!()
                return
            }

            if completionWithAnimation == true {
                UIView.defaultAnimation(innerCompletion)
            } else {
                innerCompletion()
            }
        }
    }

}

class CustomLoader: NSObject {

    private static let tagForWindowLabel: Int = 231233
    private static let tagForWindowLabelBGView: Int = 123312

    static var loadIconDictionary: [UIView: NVActivityIndicatorView] = [:]

    static func loading(_ view: UIView, enable: Bool) {
        view.isUserInteractionEnabled = enable

        if let activityIndicatorView = CustomLoader.loadIconDictionary[view] {
            view.bringSubviewToFront(activityIndicatorView)
            return
        } else {
            let height: CGFloat = 40.0
            let width: CGFloat = 40.0
            let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 50,
                                                                              y: 50,
                                                                              width: width,
                                                                              height: height),
                                                                type: .circleStrokeSpin)
            activityIndicatorView.padding = 5
            activityIndicatorView.color = .gray
            activityIndicatorView.layer.cornerRadius = 5
            activityIndicatorView.layer.borderColor = UIColor.clear.cgColor
            activityIndicatorView.layer.borderWidth = 0
            activityIndicatorView.layer.masksToBounds = true
            activityIndicatorView.backgroundColor = UIColor.clear
            view.addSubview(activityIndicatorView)
            view.bringSubviewToFront(activityIndicatorView)
            activityIndicatorView.startAnimating()
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicatorView.alpha = 0

            var constraintArray: [NSLayoutConstraint] = []

            constraintArray.append(view.centerXAnchor.constraint(equalTo: activityIndicatorView.centerXAnchor))
            constraintArray.append(view.centerYAnchor.constraint(equalTo: activityIndicatorView.centerYAnchor))
            constraintArray.append(activityIndicatorView.heightAnchor.constraint(equalToConstant: height))
            constraintArray.append(activityIndicatorView.widthAnchor.constraint(equalToConstant: width))

            NSLayoutConstraint.activate(constraintArray)

            CustomLoader.loadIconDictionary[view] = activityIndicatorView

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

                UIView.defaultAnimation({
                    activityIndicatorView.alpha = 1.0
                }, duration: 0.25)
            }
        }
    }

    /// Removing the loader from the view
    /// - Parameter view: View from which the loader need to be removed
    static func dismiss(_ view: UIView) {
        view.isUserInteractionEnabled = true

        if let activityIndicatorView = CustomLoader.loadIconDictionary[view] {
            UIView.defaultAnimation({
                activityIndicatorView.alpha = 0.0
            }, duration: 0.25, completionWithAnimation: true, completion: {
                activityIndicatorView.removeFromSuperview()
                activityIndicatorView.stopAnimating()
                CustomLoader.loadIconDictionary[view] = nil
            })
        }
    }
}

class Helper: NSObject {

    static let sharedInstance: Helper = {

        let instance = Helper()
        return instance
    }()

    func isConnectedToNetwork() -> Bool {

        if Reachability.isConnectedToNetwork() == true {

            return true

        } else {

            return false
        }
    }

    func showDefaultAlertViewController(aViewController : UIViewController, alertTitle: String, aStrMessage : String)  {

        let aAlertController = UIAlertController(title: alertTitle, message: aStrMessage, preferredStyle: UIAlertController.Style.alert)

        aAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        aViewController.present(aAlertController, animated: true, completion: nil)
    }

    func showAlertControllerWithOkCancelActionBlock(aViewController : UIViewController, aStrMessage : String, okActionBlock : @escaping (UIAlertAction) ->())  {

        let aAlertController = UIAlertController(title:  SCB.appName, message: aStrMessage, preferredStyle: UIAlertController.Style.alert)

        aAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in

            okActionBlock(action)
        }))

        aAlertController.addAction(UIAlertAction(title: "Cancel", style:  UIAlertAction.Style.cancel, handler: { (UIAlertAction) in

        }))

        aViewController.present(aAlertController, animated: true, completion: nil)
    }

    func showAlertControllerWithOkActionBlock(aViewController : UIViewController, aStrMessage : String, okActionBlock : @escaping (UIAlertAction) ->())  {

        let aAlertController = UIAlertController(title:  SCB.appName, message: aStrMessage, preferredStyle: UIAlertController.Style.alert)

        aAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in

            okActionBlock(action)
        }))

        aViewController.present(aAlertController, animated: true, completion: nil)
    }

    func setCardView(cardView : UIView)  {

        cardView.layer.masksToBounds = false
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0);
        cardView.layer.cornerRadius = 5;
        cardView.layer.shadowRadius = 1;
        cardView.layer.shadowOpacity = 0.3;

    }

    func hexStringToUIColor (hex:String) -> UIColor {

        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    func attributedString(labelType: String, labelText: String, isNext: Bool) -> NSMutableAttributedString {

        let stringValue = isNext ? (labelType + "\n" + labelText) :( labelType + labelText)
        let range = (stringValue as NSString).range(of: labelType)
        let mutableAttributedString = NSMutableAttributedString.init(string: stringValue)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: range)
        return mutableAttributedString
    }

    //MARK: - Naviagtion Bar

    func hideNavigationBar(aViewController: UIViewController) {

        aViewController.navigationController?.navigationBar.isTranslucent = false
        aViewController.navigationController?.navigationBar.isHidden = true

    }

}
