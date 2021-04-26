//
//  ContentView.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/26/21.
//

import SwiftUI

let gridSize = 15;

struct ContentView: View {
    var body: some View {
        VStack(spacing: 1){
            ForEach(0...(gridSize-1), id: \.self){ i in
                HStack(spacing: 1){
                ForEach(0...(gridSize-1), id: \.self){ j in
                    Button(action: {
                        //action
                        print("loc(\(i),\(j))")
                    }, label: {
                        Text("O")
                    })
                    .buttonStyle(CellStyle())
                }
                }
            }
        }
        .background(Color.black)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CellStyle: ButtonStyle {
    let cellSize : CGFloat = 19.0;
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: cellSize, design: .monospaced))
            .frame(width: cellSize, height: cellSize, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(2)
            .foregroundColor(Color.black)
            .background(Color.white)
//            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
