//
//  ContentView.swift
//  Rechner
//
//  Created by Jan Kott on 27.01.21.
//

import SwiftUI

/* Die Rechneransicht ist in zwei Hauptbereiche aufgeteilt, den Anzeigebereich oben und das Bedienfeld unten, wobei 2 Einheiten über dem Rechner und 1 Einheit darunter liegen */
struct RechnerView: View {
    @State var currentDisplay = "0"
    
    @State private var calculator = RechnerModel()
    
    @State private var isDraggingHandled = false
    
    @State private var isPresentingPopover = true
    
    // Callback-Funktion, wenn der Benutzer mit dem Anzeigebereich interagiert.
    private func onDisplayAreaClick(_ event: DisplayAreaEvent) -> Void {
        switch event {
        case .CopyToClipBoard:
            UIPasteboard.general.string = currentDisplay
        case .Paste:
            let content = UIPasteboard.general.string
            guard content != nil else {
                return
            }
            calculator.onPaste(content!)
            currentDisplay = calculator.displayedValue
        default:
            break
        }
    }
    
    private func onDelete() {
        calculator.onDelete()
        currentDisplay = calculator.displayedValue
    }
    
    // Callback-Funktion, wenn der Benutzer auf eine Schaltfläche im Bedienfeld klickt.
    private func onControlPanelClick(_ keyType: ButtonType) -> Void {
        switch keyType {
        case .Plus, .Minus, .Multiply, .Divide:
            calculator.onSelectOperator(keyType)
        case .Number0:
            calculator.onTypeNumber(0)
        case .Number1:
            calculator.onTypeNumber(1)
        case .Number2:
            calculator.onTypeNumber(2)
        case .Number3:
            calculator.onTypeNumber(3)
        case .Number4:
            calculator.onTypeNumber(4)
        case .Number5:
            calculator.onTypeNumber(5)
        case .Number6:
            calculator.onTypeNumber(6)
        case .Number7:
            calculator.onTypeNumber(7)
        case .Number8:
            calculator.onTypeNumber(8)
        case .Number9:
            calculator.onTypeNumber(9)
        case .Dot:
            calculator.onTypeDot()
        case .Calculate:
            calculator.onCalculate()
        case .AC:
            calculator.onAC()
        case .PlusMinus:
            calculator.onPlusMinus()
        case .Percentage:
            calculator.onPercentage()
        }
        currentDisplay = calculator.displayedValue
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(alignment: .trailing, spacing: 30.0){
                Spacer()
                Spacer()
                DisplayArea(eventCallback: onDisplayAreaClick, currentDisplay: $currentDisplay, isPresentingPopover: $isPresentingPopover)
                    .frame(maxWidth: controlPanelWidth, alignment: .trailing)
                    .padding(.trailing)
                    .frame(maxWidth: controlPanelWidth)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: buttonSize)
                            .onChanged({ value in
                                print(1)
                                guard !self.isDraggingHandled else {
                                    return
                                }
                                guard abs(value.location.y - value.startLocation.y) < buttonSize else {
                                    return
                                }
                                self.isDraggingHandled = true
                                self.onDelete()
                            })
                            .onEnded({ _ in
                                self.isDraggingHandled = false
                            })
                )
                ControlPanel(clickCallback: onControlPanelClick).padding(.bottom)
                Spacer()
            }
        }
    }
}

// Dies ist die Stammansicht. Sie enthält den Taschenrechner.
struct ContentView: View {
    var body: some View {
        RechnerView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

