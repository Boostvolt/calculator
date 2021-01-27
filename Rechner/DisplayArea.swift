//
//  DisplayArea.swift
//  Rechner
//
//  Created by Jan Kott on 27.01.21.
//

import SwiftUI

enum DisplayAreaEvent {
    case Delete
    case CopyToClipBoard
    case Paste
}

// Anzeigebereich zeigt aktuelles Ergebnis an
struct DisplayArea: View {
    var eventCallback: ((DisplayAreaEvent) -> Void)?
    
    // Anzeigetext vom Taschenrechner binden
    @Binding var currentDisplay: String
    
    @Binding var isPresentingPopover: Bool
    
    // Dynamische Schriftgrösse für unterschiedliche Anzeigetextlängen, so dass sie die Bedienfeldbreite nicht überschreitet
    var fontSize: CGFloat {
        get {
            if currentDisplay.count > 11 {
                return 70
            } else if currentDisplay.count > 9 {
                return 75
            } else if currentDisplay.count > 8 {
                return 80
            } else {
                return 100
            }
        }
    }
    
    var body: some View {
        Text(currentDisplay)
            .foregroundColor(Color.white)
            .font(.system(size: fontSize))
            .contextMenu {
                Button(action: {
                    self.eventCallback?(.CopyToClipBoard)
                }) {
                    Text("Kopieren")
                    Image(systemName: "doc.on.doc")
                }
                Button(action: {
                    self.eventCallback?(.Paste)
                }) {
                    Text("Einfügen")
                    Image(systemName: "doc.on.clipboard")
                }
        }
        .id(UUID.init())
        .frame(minHeight: 120)
    }
}

struct DisplayArea_Previews: PreviewProvider {
    static var previews: some View {
        RechnerView()
    }
}

