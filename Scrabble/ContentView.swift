//
//  ContentView.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/26/21.
//

import SwiftUI

let gridSize = Logic.gridSize
let alphabet = Logic.alphabet
struct ContentView: View {
    @State var matrix = Logic.matrix
    @State var prevMatrix = Logic.matrix
    @State var pieceSet = Logic.getNewSet()
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
                                    if(!Logic.isContiguous(matrix)){
                                        print("Not one island, reverting")
                                        matrix[i][j] = ""
                                        selectedAlphabet = ""
                                    } else {
                                        currentWord.append(selectedAlphabet)
                                        for i in pieceSet.indices.reversed() where pieceSet[i] == selectedAlphabet {
                                            pieceSet.remove(at: i)
                                            break
                                        }
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
                .foregroundColor(selectedAlphabet == a ? Color.white :colorMap[Logic.scoreMap[a]!])
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
        HStack(spacing: 20){
            Button(
                action: {
                    //action
                    matrix = prevMatrix
                    for i in currentWord{
                        pieceSet.append(String(i))
                    }
                    currentWord = ""
                    selectedAlphabet = ""
                }){
                Image(systemName: "xmark")
            }
            .padding()
            .background(Color(red: 0.6, green: 0.6, blue: 0.6))
            .foregroundColor(.white)
            .clipShape(Capsule())
            
            Button(
                action: {
                    //action
                    if pieceSet.count > 1 {
                        pieceSet.shuffle()
                    }
                }){
                Image(systemName: "shuffle")
            }
            .padding()
            .background(Color(red: 0.2, green: 0.8, blue: 0.8))
            .foregroundColor(.white)
            .clipShape(Capsule())
            
            Button(
                action: {
                    //action
                    if(reserveCount == 0 && pieceSet.count != 0){
                        var count = pieceSet.count - 1
                        for _ in currentWord{
                            count += 1
                        }
                        pieceSet = []
                        
                        while count > 0 {
                            pieceSet.append(Logic.getNewCharacter())
                            count -= 1
                        }
                        score -= 5
                    } else if( reserveCount > 0 && (pieceSet.count + currentWord.count) > 0) {  matrix = prevMatrix
                        pieceSet = []
                        while pieceSet.count < 9 {
                            pieceSet.append(Logic.getNewCharacter())
                        }
                        currentWord = ""
                        selectedAlphabet = ""
                        reserveCount -= 1;
                    }
                    
                }){
                Image(systemName: "arrow.clockwise")
            }
            .padding()
            .background(Color(red: 0.9, green: 0.1, blue: 0.1))
            .foregroundColor(.white)
            .clipShape(Capsule())
            
            Button(
                action: {
                    if( currentWord.count > 2 && Words.checkIfWord(currentWord)){
                        // reset state
                        print("Current word: \(currentWord)")
                        score += Logic.calcWordScore(word: currentWord)
                        prevMatrix = matrix
                        currentWord = ""
                        selectedAlphabet = ""
                        
                        // get new pieces
                        if(pieceSet.count<9){
                            print(pieceSet.count, 8-pieceSet.count)
                            for n in 0...(8-pieceSet.count) {
                                if(reserveCount > 0){
                                    pieceSet.append(Logic.getNewCharacter())
                                    reserveCount -= 1;
                                }
                            }
                        }
                    }
                    else{
                        // reseting since not a word
                        print("Not a word!")
                        matrix = prevMatrix
                        for i in currentWord{
                            pieceSet.append(String(i))
                        }
                        currentWord = ""
                        selectedAlphabet = ""
                    }
                }){
                Image(systemName: "play")
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
