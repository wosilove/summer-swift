import UIKit
import Atributika

class Settings {
    struct Url {
        static let baseURL = NSURL(string: "https://www.regent-college.edu/summer")!
    }

    struct Font {
        static let headerFont = UIFont(name: "Futura-Bol", size: 18)!
        static let paragraphFont = UIFont(name: "Futura-Lig", size: 16)!
        static let obliqueFont = UIFont(name: "Futura-LigObl", size: 16)!
    }
    
    struct Style {
        static let h1 = Atributika.Style("h1").font(Settings.Font.headerFont)
        static let em = Atributika.Style("em").font(Settings.Font.obliqueFont)
        static let paragraph = Atributika.Style.font(Settings.Font.paragraphFont)
    }
    
    struct Color {
        static let red = "fa3737".hexColor
        static let orange = "ff690e".hexColor
    }
}