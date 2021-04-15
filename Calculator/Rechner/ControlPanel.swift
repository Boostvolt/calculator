//
//  ControlPanel.swift
//  Rechner
//
//  Created by Jan Kott on 27.01.21.
//

import SwiftUI

/* Die Größe und der Abstand der Schaltflächen, die zur Laufzeit anhand der Bildschirmgrösse berechnet werden die Strategie zur Berechnung der Größe der Schaltflächen besteht darin,
   die kürzeste Seite des Bildschirms (Höhe oder Breite) zu finden und die Gesamtlänge des Bildschirms durch 7 zu teilen (5 Reihen Schaltflächen + 2 Reihen Abstand) */
var buttonGapSize: CGFloat = (UIScreen.main.bounds.height > UIScreen.main.bounds.width) ?
    (UIScreen.main.bounds.width / 50) :
    (UIScreen.main.bounds.height / 50)
var buttonSize: CGFloat = (UIScreen.main.bounds.height > UIScreen.main.bounds.width) ?
    ((UIScreen.main.bounds.width - 4 * buttonGapSize) / 7):
    ((UIScreen.main.bounds.height - 4 * buttonGapSize) / 7)

var controlPanelWidth = 4 * buttonSize + 3 * buttonGapSize

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}

struct ControlPanel: View {
    var clickCallback: ((ButtonType) -> Void)?
    
    // Farben
    private let BGGray = Color(hex: 0xa5a5a5)
    private let BGHoverGray = Color(hex: 0xd9d9d9)
    
    private let BGDarkGray = Color(hex: 0x333333)
    private let BGHoverDarkGray = Color(hex: 0x737373)
    
    private let BGOrange = Color(hex: 0xff9f06)
    private let BGHoverOrange = Color(hex: 0xfcc88d)
    
    private let FGWhite = Color(.white)
    private let FGBlack = Color(.black)
    
    // Der Operator, der ausgewählt ist. nil, wenn nicht ausgewählt.
    @State private var selectedOperator: ButtonType? = nil
    
    // Callback-Funktion für Schaltflächen bei Klick.
    private func onButtonClick(_ buttonType: ButtonType) -> Void {
        switch buttonType {
        case .Divide, .Multiply, .Minus, .Plus:
            self.selectedOperator = buttonType
        case .Calculate:
            self.selectedOperator = nil
        default:
            break
        }
        self.clickCallback?(buttonType)
    }
    
    var body: some View {
        // Hier ist eine Liste mit 5 Reihen von Schaltflächen, jede Reihe von Schaltflächen enthält die spezifischen Schaltflächen und definiert ihr Symbol, ihre Farben und alle ihre Eigenschaften.
        VStack(spacing: buttonGapSize) {
            HStack(spacing: buttonGapSize) {
                RechnerButton(text: "AC", BG: BGGray, FG: FGBlack, BGHover: BGHoverGray, operatorType: ButtonType.AC, selectedOperator: $selectedOperator, callback: onButtonClick)
                RechnerButton(image: Image(systemName: "plus.slash.minus"), BG: BGGray, FG: FGBlack, BGHover: BGHoverGray, operatorType: ButtonType.PlusMinus, selectedOperator: $selectedOperator, callback: onButtonClick)
                RechnerButton(text: "%", BG: BGGray, FG: FGBlack, BGHover: BGHoverGray, operatorType: ButtonType.Percentage, selectedOperator: $selectedOperator, callback: onButtonClick)
                RechnerButton(image: Image(systemName: "divide"), BG: BGOrange, FG: FGWhite, BGHover: BGHoverOrange, operatorType: ButtonType.Divide, selectedOperator: $selectedOperator, callback: onButtonClick)
            }
            HStack(spacing: buttonGapSize) {
                RechnerButton(text: "7", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number7, selectedOperator: $selectedOperator, callback: onButtonClick)
                RechnerButton(text: "8", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number8, selectedOperator: $selectedOperator, callback: onButtonClick)
                RechnerButton(text: "9", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number9, selectedOperator: $selectedOperator, callback: onButtonClick)
                RechnerButton(image: Image(systemName: "multiply"), BG: BGOrange, FG: FGWhite, BGHover: BGHoverOrange, operatorType: ButtonType.Multiply, selectedOperator: $selectedOperator, callback: onButtonClick)
            }
            HStack(spacing: buttonGapSize) {
                RechnerButton(text: "4", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number4, selectedOperator: $selectedOperator, callback: onButtonClick)
                RechnerButton(text: "5", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number5, selectedOperator: $selectedOperator, callback: onButtonClick)
                RechnerButton(text: "6", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number6, selectedOperator: $selectedOperator, callback: onButtonClick)
                RechnerButton(image: Image(systemName: "minus"), BG: BGOrange, FG: FGWhite, BGHover: BGHoverOrange, operatorType: ButtonType.Minus, selectedOperator: $selectedOperator, callback: onButtonClick)
            }
            HStack(spacing: buttonGapSize) {
                RechnerButton(text: "1", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number1, selectedOperator: $selectedOperator, callback: onButtonClick)
                RechnerButton(text: "2", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number2, selectedOperator: $selectedOperator, callback: onButtonClick)
                RechnerButton(text: "3", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number3, selectedOperator: $selectedOperator, callback: onButtonClick)
                RechnerButton(image: Image(systemName: "plus"), BG: BGOrange, FG: FGWhite, BGHover: BGHoverOrange, operatorType: ButtonType.Plus, selectedOperator: $selectedOperator, callback: onButtonClick)
            }
            HStack(spacing: buttonGapSize) {
                RechnerButton(text: "0", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, horizontalSpan: 2, operatorType: ButtonType.Number0, selectedOperator: $selectedOperator, callback: onButtonClick)
                RechnerButton(text: ".", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Dot, selectedOperator: $selectedOperator, callback: onButtonClick)
                RechnerButton(image: Image(systemName: "equal"), BG: BGOrange, FG: FGWhite, BGHover: BGHoverOrange, operatorType: ButtonType.Calculate, selectedOperator: $selectedOperator, callback: onButtonClick)
            }
        }
    }
}

struct ControlPanel_Previews: PreviewProvider {
    static var previews: some View {
        ControlPanel()
    }
}

