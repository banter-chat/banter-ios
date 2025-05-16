//error nil

import SwiftUI

extension View{
    func font(font: Nunito, size: CGFloat = 16) -> some View{
        self.font(Font.custom(font.rawValue, size: size))
    }
}
