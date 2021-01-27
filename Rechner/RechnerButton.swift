//
//  RechnerButton.swift
//  Rechner
//
//  Created by Jan Kott on 27.01.21.
//

import SwiftUI

// Alle möglichen Tastentypen
enum ButtonType {
    case Plus
    case Minus
    case Multiply
    case Divide
    case Number0
    case Number1
    case Number2
    case Number3
    case Number4
    case Number5
    case Number6
    case Number7
    case Number8
    case Number9
    case Dot
    case Calculate
    case AC
    case PlusMinus
    case Percentage
}

struct RechnerButton: View {
    
    // Optional für ein Symbolbild. wenn das Bild angegeben ist, wird das Bild verwendet. andernfalls muss ein Symboltext angegeben werden.
    var image: Image?
    var text: String = ""
    
    // Hintergrund- und Vordergrundfarben, können angepasst werden.
    var BG: Color = .gray
    var FG: Color = .white
    
    // animierte Farben bei Klick, optional wenn nicht angegeben, wird stattdessen die foregroundColor/backgroundColor verwendet, sodass keine Farbanimationen beobachtet werden
    var BGHover: Color?
    var FGHover: Color?
    
    // Die Anzahl der Spalten, über die es sich erstreckt. Standardmässig ist die Breite 1 Einheit der Schaltfläche. Muss eine ganze Zahl sein.
    var horizontalSpan: CGFloat = 1.0
    
    // Der Operatortyp der Tasteninstanz.
    let operatorType: ButtonType
    
    // Der gewählte Operatortyp wird im ControlPanel angesteuert.
    @Binding var selectedOperator: ButtonType?
    
    // Schaltfläche bei Klick Callback.
    var callback: ((ButtonType) -> Void)?
    
    // Verfolgung, ob die Schaltfläche aktuell auf Hover steht.
    @State private var isTouching = false
    
    // Berechnete überspannte Breite für internen Gebrauch.
    private var spannedWidth: CGFloat {
        get {
            buttonSize * horizontalSpan + (horizontalSpan - 1) * buttonGapSize
        }
    }
    
    private var shouldInvertColor: Bool {
        get {
            switch operatorType {
            case .Divide, .Multiply, .Plus, .Minus:
                if selectedOperator == operatorType {
                    return true
                } else {
                    return false
                }
            default:
                return false
            }
        }
    }
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            Text("")
                .cornerRadius(buttonSize / 2)
                .frame(width: spannedWidth, height: buttonSize)
                .background(shouldInvertColor ? FG : self.isTouching ? (BGHover ?? BG) : BG)
                .animation(shouldInvertColor ? .spring() : self.isTouching ? nil : .spring())
                .cornerRadius(buttonSize / 2)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ (touch) in
                            let isOutsideView = (touch.location.y < 0 || touch.location.x < 0 || touch.location.y > buttonSize || touch.location.x > self.spannedWidth)
                            let isIntsideView = (touch.location.y >= 0 && touch.location.x >= 0 && touch.location.y <= buttonSize && touch.location.x <= self.spannedWidth)
                            if self.isTouching && isOutsideView {
                                self.onMoveOutView()
                            } else if !self.isTouching && isIntsideView {
                                self.onMoveIntoView()
                            }
                        })
                        .onEnded({ (touch) in
                            self.onMoveEnd()
                            }
                    )
            )
            Group {
                if image != nil {
                    image?
                        .resizable()
                        .scaledToFit()
                        .frame(width: buttonSize / 3, height: buttonSize / 3)
                        .padding(buttonSize / 3)
                        .foregroundColor(shouldInvertColor ? BG : FG)
                        .animation(.spring())
                    
                } else {
                    Text(text)
                        .frame(width: buttonSize / 2, height: buttonSize / 2)
                        .font(.system(size: 500))
                        .minimumScaleFactor(0.01)
                        .padding(buttonSize / 4)
                        .foregroundColor(shouldInvertColor ? BG : FG)
                        .animation(.spring())
                }
            }
        }
    }
    
    // Figur bewegt sich aus dem Tastenanzeigebereich heraus
    private func onMoveIntoView() {
        self.isTouching = true
    }
    
    // Figur bewegt sich in den Tastenanzeigebereich.
    private func onMoveOutView() {
        self.isTouching = false
    }
    
    // Bewegung beendet, wenn Figur innerhalb des Tastenanzeigebereichs, Aufruf der Callback-Funktion. Rücksetzen ist berührend auf false.
    private func onMoveEnd() {
        if self.isTouching {
            self.callback?(self.operatorType)
        }
        self.isTouching = false
    }
}

struct RechnerButton_Previews: PreviewProvider {
    static var previews: some View {
        ControlPanel()
    }
}

