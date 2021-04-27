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
    @State var prevMatrix = GameConstants.matrix
    @State var pieceSet = GameConstants.getNewSet()
    @State var selectedAlphabet = ""
    @State var currentWord = ""
    @State var score = 0
    @State var reserveCount = 9
    
    var body: some View {
        
        Text("Score: \(score)    [\(reserveCount ) left]")
            .font(.system(size: 24, design: .monospaced))
            .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(2)
            .foregroundColor(Color.blue)
            .background(Color.white);
        
        Spacer().frame(height: 10);
        
        VStack(spacing: 1){
            ForEach(0...(gridSize-1), id: \.self){ i in
                HStack(spacing: 1){
                ForEach(0...(gridSize-1), id: \.self){ j in
                    Button(
                        action: {
                            //action
                            if(selectedAlphabet != ""){
                                if(matrix[i][j] == ""){
                                    matrix[i][j] = selectedAlphabet
                                    
                                    //check if new char is part of the existing logic
                                    if(!Helpers.isContiguous(matrix)){
                                        print("Not one island, reverting")
                                        matrix[i][j] = ""
                                        selectedAlphabet = ""
                                    } else {
                                        currentWord.append(selectedAlphabet)
                                        for i in pieceSet.indices.reversed() where pieceSet[i] == selectedAlphabet {
                                            pieceSet.remove(at: i)
                                            break
                                        }
                                        print(currentWord)
                                        selectedAlphabet = ""
                                    }

                                } else{
                                    print("not empty: \(matrix[i][j])")
                                }
                            }
                        }){
                        Text(matrix[i][j])
                    }
                    .buttonStyle(CellStyle())
                }
                }
            }
        }
        .background(Color.black)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
        
        // Pieces
        HStack(spacing: 1){
            ForEach(pieceSet, id: \.self){ a in
                Button(
                    action: {
                        //action
                        selectedAlphabet = a
                    }){
                    Text(a)
                }
                .buttonStyle(PieceStyle())
                .foregroundColor(selectedAlphabet == a ? Color.white :colorMap[GameConstants.scoreMap[a]!])
                .background(selectedAlphabet == a ? Color.black : Color.white)
            }
        }
        
        // currentWord
        Text("'\(currentWord)'")
            .underline()
            .font(.system(size: 40, design: .monospaced))
            .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(2)
            .foregroundColor(Color.black)
            .background(Color.white);
            
        Spacer().frame(height: 20);
        
        // Buttons
        HStack(spacing: 10){
            Button(
                action: {
                    //action
                    matrix = prevMatrix
                    currentWord = ""
                    selectedAlphabet = ""
                }){
                Text("Cancel")
            }
            .padding()
            .background(Color(red: 0.8, green: 0.1, blue: 0.1))
            .foregroundColor(.white)
            .clipShape(Capsule())
            
            Spacer()
                    .frame(width: 50)
            
            Button(
                action: {
                    
                    // reset state
                    print("Current word: \(currentWord)")
                    score += GameConstants.calcWordScore(word: currentWord)
                    prevMatrix = matrix
                    currentWord = ""
                    selectedAlphabet = ""
                    
                    
                    // get new pieces
                    if(pieceSet.count<9){
                        print(pieceSet.count, 8-pieceSet.count)
                        for n in 0...(8-pieceSet.count) {
                            if(reserveCount > 0){
                                pieceSet.append(GameConstants.getNewCharacter())
                                reserveCount -= 1;
                            }
                        }
                    }
                }){
                Text("Submit")
            }
            .padding()
            .background(Color(red: 0.1, green: 0.8, blue: 0.1))
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
    }
    
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

struct PieceStyle: ButtonStyle {
    let cellSize : CGFloat = 38.0;
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: cellSize, design: .monospaced))
            .frame(width: cellSize, height: cellSize, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(1)
//            .foregroundColor(Color.black)
//            .background(Color.white)
            .border(Color.black, width: 2)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
let colorMap: [Int: Color] = [
    0: Color.white,
    1: Color.black,
    2: Color.yellow,
    3: Color.green,
    4: Color.blue,
    5: Color.purple,
    8: Color.orange,
    10: Color.red
]
