//
//  UIColors+Extensions.swift
//  Tracker
//
//  Created by Игорь Полунин on 22.06.2023.
//

import UIKit

extension UIColor {
    static var TrackerWhite: UIColor {
        UIColor(named: "TrackerWhite") ?? .white
    }
    static var TrackerBlack: UIColor {
        UIColor(named: "TrackerBlack") ?? .black
    }
    static var TrackerBackGround: UIColor {
        UIColor(named: "BackGroundDay") ?? .systemBackground
    }
    static var EmojiBackGround: UIColor {
        UIColor(named: "EmojiBackGround") ?? .systemBackground
    }
    
    static var BackGroundDay: UIColor {
        UIColor(named: "BackGroundDay") ?? UIColor.black
    }
    static var BackGroundNight: UIColor {
        UIColor(named: "BackGroundNight") ?? UIColor.black
    }
    static var BlackDay: UIColor {
        UIColor(named: "BlackDay") ?? UIColor.black
    }
    static var Blue: UIColor {
        UIColor(named: "Blue") ?? UIColor.blue
    }
    static var Gray: UIColor {
        UIColor(named: "Gray") ?? UIColor.gray
    }
    static var Red: UIColor {
        UIColor(named: "Red") ?? UIColor.red
    }
    static var WhiteDay: UIColor {
        UIColor(named: "WhiteDay") ?? UIColor.white
    }
    static var WhiteNight: UIColor {
        UIColor(named: "WhiteNight") ?? UIColor.black
    }
    static var ColorSelection1: UIColor {
        UIColor(named: "ColorSelection1") ?? UIColor.red
    }
    static var ColorSelection2: UIColor {
        UIColor(named: "ColorSelection2") ?? UIColor.orange
    }
    static var ColorSelection3: UIColor {
        UIColor(named: "ColorSelection3") ?? UIColor.blue
    }
    static var ColorSelection4: UIColor {
        UIColor(named: "ColorSelection4") ?? UIColor.blue
    }
    static var ColorSelection5: UIColor {
        UIColor(named: "ColorSelection5") ?? UIColor.green
    }
    static var ColorSelection6: UIColor {
        UIColor(named: "ColorSelection6") ?? UIColor.systemPink
    }
    static var ColorSelection7: UIColor {
        UIColor(named: "ColorSelection7") ?? UIColor.white
    }
    static var ColorSelection8: UIColor {
        UIColor(named: "ColorSelection8") ?? UIColor.blue
    }
    static var ColorSelection9: UIColor {
        UIColor(named: "ColorSelection9") ?? UIColor.green
    }
    static var ColorSelection10: UIColor {
        UIColor(named: "ColorSelection10") ?? UIColor.blue
    }
    static var ColorSelection11: UIColor {
        UIColor(named: "ColorSelection11") ?? UIColor.orange
    }
    static var ColorSelection12: UIColor {
        UIColor(named: "ColorSelection12") ?? UIColor.systemPink
    }
    static var ColorSelection13: UIColor {
        UIColor(named: "ColorSelection13") ?? UIColor.yellow
    }
    static var ColorSelection14: UIColor {
        UIColor(named: "ColorSelection14") ?? UIColor.blue
    }
    static var ColorSelection15: UIColor {
        UIColor(named: "ColorSelection15") ?? UIColor.magenta
    }
    static var ColorSelection16: UIColor {
        UIColor(named: "ColorSelection16") ?? UIColor.blue
    }
    static var ColorSelection17: UIColor {
        UIColor(named: "ColorSelection17") ?? UIColor.blue
    }
    static var ColorSelection18: UIColor {
        UIColor(named: "ColorSelection18") ?? UIColor.green
    }
}

extension UIColor {
  static func == (l: UIColor, r: UIColor) -> Bool {
    var r1: CGFloat = 0
    var g1: CGFloat = 0
    var b1: CGFloat = 0
    var a1: CGFloat = 0
    l.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
    var r2: CGFloat = 0
    var g2: CGFloat = 0
    var b2: CGFloat = 0
    var a2: CGFloat = 0
    r.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
    return r1 == r2 && g1 == g2 && b1 == b2 && a1 == a2
  }
}
func == (l: UIColor?, r: UIColor?) -> Bool {
  let l = l ?? .clear
  let r = r ?? .clear
  return l == r
}
extension CGColor: Equatable { }
