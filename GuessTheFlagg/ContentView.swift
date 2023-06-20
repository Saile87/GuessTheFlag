//
//  ContentView.swift
//  GuessTheFlagg
//
//  Created by Elias Breitenbach on 09.02.23.
//
import SwiftUI

struct FlagImage: View {
    var body: some View {
        
        Image(name)
            .clipShape(Capsule())
            .shadow(radius: 4)
            .font(.largeTitle)
            .padding(4)
    }
    let name: String
    init(name: String) {
        self.name = name
    }
}
struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var controlingGameRound = false
    @State private var gameOver = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var counter = 0
    @State private var animationAmount = 0.0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.1), location: 0.6),
                .init(color: Color(red: 0.2, green: 0.1, blue: 0.2), location: 0.8),
            ], center: .top, startRadius: 200, endRadius: 500)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the Flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                                withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                                    animationAmount += 360
                                }
                            self.counter += 1
                            if self.counter >= 8 {
                                self.controlingGameRound = true
                            }
                            flagTapped(number)
                        } label: {
                            FlagImage(name: countries[number])
                        }
                            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                
                Spacer()
                Spacer()
                
                Text("Score \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
            
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your Score is: \(score)")
            
        }
        .alert(gameOver, isPresented: $controlingGameRound) {
            Button("RESET", action: reset)
        } message: {
            Text("Highscore is: \(score)")
        }
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else if number != correctAnswer {
            scoreTitle = ("Wrong that's flag of: \(countries[number])")
            score -= 1
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    func reset() {
        countries.shuffle()
        score = 0
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
