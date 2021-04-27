//
//  ContentView.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/26/21.
//

import SwiftUI

let gridSize = GameConstants.gridSize
let alphabet = GameConstants.alphabet
struct ContentView: View {
    @State var matrix = GameConstants.matrix
    @State var selectedAlphabet = ""
    
    var body: some View {
        VStack(spacing: 1){
            ForEach(0...(gridSize-1), id: \.self){ i in
                HStack(spacing: 1){
                ForEach(0...(gridSize-1), id: \.self){ j in
                    Button(
                        action: {
                            //action
                            if(selectedAlphabet != ""){
                                if(matrix[i][j] == ""){
                                    print("\(selectedAlphabet): loc(\(i),\(j))")
                                    matrix[i][j] = selectedAlphabet
                                    selectedAlphabet = ""
                                    
                                    if(Helpers.isContiguous(matrix)){
                                        print("Still one island, commiting change")
                                    } else {
                                        print("Not one island, reverting")
                                        matrix[i][j] = ""
                                    }
                                } else{
                                    print("not empty: \(matrix[i][j])")
                                }
                            }
                        }){
                        Text("\(matrix[i][j])")
                    }
                    .buttonStyle(CellStyle())
                }
                }
            }
        }
        .background(Color.black)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
        
        ///
        HStack(spacing: 1){
            ForEach(0...12, id: \.self){ a in
                Button(
                    action: {
                        //action
                        selectedAlphabet = alphabet[a]
                    }){
                    Text(alphabet[a])
                }
                .buttonStyle(CellStyle())
            }
        }
        HStack(spacing: 1){
            ForEach(13...25, id: \.self){ a in
                Button(
                    action: {
                        //action
                        selectedAlphabet = alphabet[a]
                    }){
                    Text(alphabet[a])
                }
                .buttonStyle(CellStyle())
            }
        }
        ///
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CellStyle: ButtonStyle {
    let cellSize : CGFloat = 22.0;
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: cellSize, design: .monospaced))
            .frame(width: cellSize, height: cellSize, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(1)
            .foregroundColor(Color.black)
            .background(Color.white)
//            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
}
