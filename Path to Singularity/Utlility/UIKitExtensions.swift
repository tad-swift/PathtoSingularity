//
//  Extensions.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 4/2/21.
//

import UIKit

extension Double {
    var abbreviated: String {
        if self > 10_000 {
            let abbrev = ["K","M","B","T","Qa","Qi","Sx","Sp","Oc","No","Dc","Ud"]
            return abbrev.enumerated().reversed().reduce(nil as String?) { accum, tuple in
                let factor = self / pow(10, Double(tuple.0 + 1) * 3)
                if self <= 1_000_000 {
                    let format = (factor.truncatingRemainder(dividingBy: 1)  == 0 ? "%.0f%@" : "%.1f%@")
                    return accum ?? (factor > 1 ? String(format: format, factor, String(tuple.1)) : nil)
                } else {
                    let format = (factor.truncatingRemainder(dividingBy: 1)  == 0 ? "%.0f%@" : "%.3f%@")
                    return accum ?? (factor > 1 ? String(format: format, factor, String(tuple.1)) : nil)
                }
                
            } ?? String(self)
        } else {
            return String(format: "%.0f", self)
        }
    }
}

extension UIFont {
    static func roundedFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        let descriptor = UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor.withDesign(.rounded)!
        return UIFont(descriptor: descriptor, size: fontSize)
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
}
