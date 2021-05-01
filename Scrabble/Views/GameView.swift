//
//  ContentView.swift
//  Scrabble
//
//  Created by Nikhil Shankar on 4/26/21.
//

import SwiftUI

let gridSize = Logic.gridSize
let alphabet = Logic.alphabet

var gameState = Game.getGameState()
var thisUser = Game.getThisUserState()

struct GameView: View {
    // live state?
//    @State var board = gameState.board
//    @State var prevBoard = gameState.board
//    @State var pieceSet = thisUser.pieceSet
//    @State var isMyTurn = thisUser.isMyTurn
//    @State var reserveCount = thisUser.reserveCount
//    @State var score = thisUser.score
    
    @State var board = Logic.emptryBoard
    @State var prevBoard = Logic.emptryBoard
    @State var pieceSet = Logic.getNewSet()
    @State var isMyTurn = false
    @State var reserveCount = 10
    @State var score = 0
    
    // local state
    @State var selectedAlphabet = ""
    @State var currentWord = ""
    @State var toastText = ""
    @State var showToast: Bool = false
    @State var updatedCoords = [[Int]]()
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 15){
            Spacer();
            
            Text("Score: \(score)    [\(reserveCount ) left]")
                .font(.system(size: 24, design: .monospaced))
                .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(2)
                .foregroundColor(Color.blue)
                .background(Color.white);
        
            VStack(spacing: 1){
                ForEach(0...(gridSize-1), id: \.self){ i in
                    HStack(spacing: 1){
                    ForEach(0...(gridSize-1), id: \.self){ j in
                        Button(
                            action: {
                                //action
                                if(selectedAlphabet != "" && (board[i]?[j])! == " "){
                                    // check if new move is legit
                                    board[i]?[j] = selectedAlphabet // new move
                                    currentWord.append(selectedAlphabet)
                                    
                                    for i in pieceSet.indices.reversed() where pieceSet[i] == selectedAlphabet {
                                        pieceSet.remove(at: i)
                                        break
                                    }
                                    selectedAlphabet = ""
                                    updatedCoords.append([i,j])
                                }
                            
                            }){
                            Text(board[i]?[j]!)
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
            // Buttons
            HStack(spacing: 20){
    
                Button(
                    action: {
                        //action
                        board = prevBoard
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
                        } else if(
                                reserveCount > 0 &&
                                (pieceSet.count + currentWord.count) > 0) {
                            board = prevBoard
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
                        if( currentWord.count > 1 &&
                            Logic.checkIfWordAndBoard(board: board, updatedCoords: updatedCoords) // ###
                        ){
                            // reset state
                            updatedCoords = []; // ###
                            score += Logic.calcWordScore(word: currentWord)
                            prevBoard = board
                            currentWord = ""
                            selectedAlphabet = ""
                            
                            // get new pieces
                            if(pieceSet.count<9){
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
                            board = prevBoard
                            for i in currentWord{
                                pieceSet.append(String(i))
                            }
                            updatedCoords = []; // ###
                            currentWord = ""
                            selectedAlphabet = ""
                            
                            toastText = "Not a word!"
                            showToast = true
                        }
                    }){
                    Image(systemName: "play")
                }
                .padding()
                .background(Color(red: 0.1, green: 0.8, blue: 0.1))
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            Spacer();
        }
        .toast(isShowing: $showToast, text: Text(toastText))
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .background(Color.black).ignoresSafeArea(.all)
    }
    
    func postData(){
        print(score,reserveCount)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
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
