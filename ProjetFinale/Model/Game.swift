//
//  Game.swift
//  OpenQuizz
//
//  Created by Ambroise COLLON on 13/06/2017.
//  Copyright Â© 2017 OpenClassrooms. All rights reserved.
//

import Foundation


class Game {
    
    static let QUESTIONS_LOADED = Notification.Name("QuestionsLoaded")
    static let RIGHT_ANSWER = Notification.Name("RightAnswer")
    static let WRONG_ANSWER = Notification.Name("WrongAnswered")
    
    var score = 0
    
    private var questions = [Question]()
    private var currentIndex = 0
    
//    init() {
//        self.refresh()
//    }
    
    var state: State = .ongoing

    enum State {
        case ongoing, over
    }

    func refresh() {
        score = 0
        currentIndex = 0
        state = .over
        
        QuestionManager.shared.get { (questions) in
            self.questions = questions
            
            self.state = .ongoing
            
            let questionsLoadedNotifName = Game.QUESTIONS_LOADED
            let notification = Notification(name: questionsLoadedNotifName, object: self)
            
            NotificationCenter.default.post(notification)
        }
    }
    
    var currentQuestion: Question {
        return questions[currentIndex]
    }

    func answerCurrentQuestion(with answer: Bool) {
        if (currentQuestion.isCorrect && answer) || (!currentQuestion.isCorrect && !answer) {
            self.score += 1
            let notification = Notification(name: Game.RIGHT_ANSWER, object: self)
            NotificationCenter.default.post(notification)
        } else {
            let notification = Notification(name: Game.WRONG_ANSWER, object: self)
            NotificationCenter.default.post(notification)
        }
        goToNextQuestion()
    }

    private func goToNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            finishGame()
        }
    }

    private func finishGame() {
        state = .over
    }
}
