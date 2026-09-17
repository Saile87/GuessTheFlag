//
//  ContentView.swift
//  GuessTheFlagg
//
//  Created by Elias Breitenbach on 09.02.23.
//
import SwiftUI

struct FlagImage: View {
    let name: String

    var body: some View {
        Image(name)
            .clipShape(Capsule())
            .shadow(radius: 4)
            .padding(4)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var controlingGameRound = false
    @State private var gameOver = "Game Over"
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var counter = 0
    @State private var animationAmount = 0.0
    @State private var selectedFlag: Int? = nil

    @AppStorage("highscore") private var highscore = 0

    private let questionsPerRound = 8

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
                            flagTapped(number)
                        } label: {
                            FlagImage(name: countries[number])
                        }
                        .rotation3DEffect(
                            .degrees(selectedFlag == number ? animationAmount : 0),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .opacity(selectedFlag == nil || selectedFlag == number ? 1 : 0.25)
                        .scaleEffect(selectedFlag == nil || selectedFlag == number ? 1 : 0.85)
                        .animation(.default, value: selectedFlag)
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
            Text("Final Score: \(score)\nHighscore is: \(highscore)")
        }
    }

    func flagTapped(_ number: Int) {
        selectedFlag = number
        withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
            animationAmount += 360
        }

        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong that's flag of: \(countries[number])"
            score -= 1
        }

        if score > highscore {
            highscore = score
        }

        counter += 1
        if counter >= questionsPerRound {
            controlingGameRound = true
        } else {
            showingScore = true
        }
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = nil
    }

    func reset() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        score = 0
        counter = 0
        selectedFlag = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
