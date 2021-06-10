//
//  ViewController.swift
//  ProjetFinale
//
//  Created by Siarhei Saukin (Étudiant) on 2021-06-07.
//  Copyright © 2021 Siarhei Saukin (Étudiant). All rights reserved.
//

import UIKit

class ViewController:UIViewController {
    
    let GAME_OVER = "GAME OVER"
    let game: Game = Game()
    
    @IBOutlet weak var gifView: UIImageView?
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBOutlet weak var sliderView: SliderView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var questionView: QuestionView!
    
    @IBOutlet weak var progress: UIProgressView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNewGame()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setMainView), name: Game.QUESTIONS_LOADED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setNewQuestion(notification:)), name: Game.RIGHT_ANSWER, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setNewQuestion(notification:)), name: Game.WRONG_ANSWER, object: nil)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        questionView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setUpNewGame() {
        for v in self.view.subviews {
            v.isHidden = true
        }
        loadingLabel.isHidden = false
        scoreLabel.text = "0 / 10"
        progress.progress = 0.0
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
        game.refresh()
    }
    
    @objc func setMainView() {
        loadingLabel.isHidden = true
        questionView.title = game.currentQuestion.title
        var delay: Float = 0.0
        for v in self.view.subviews {
            if let temp = v as? UILabel {
                if temp.isEqual(loadingLabel) {
                    continue
                }
            }
            animateShowView(v, customDelay: delay)
            delay += 0.4
        }
    }
    
    @objc func dragQuestionView(_ sender: UIPanGestureRecognizer) {
        if game.state == .ongoing {
            switch sender.state {
            case .began, .changed :
                transformQuestionView(gesture: sender)
            case .cancelled, .ended :
                answerQuestion()
            default:
                break
            }
        }
    }
    
    @objc func setNewQuestion(notification: Notification) {
        
        if notification.name == Game.RIGHT_ANSWER {
            scoreLabel.text = "\(game.score) / 10"
            animateShowView(scoreLabel, customDelay: 0.0)
        } else {
            if (questionView.style == .incorrect) {
                questionView.style = .correct
            } else {
                questionView.style = .incorrect
            }
        }
    }
    
    private func transformQuestionView(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: questionView)
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        let screenWidth = UIScreen.main.bounds.width
        let translationPercent = translation.x / (screenWidth / 2)
        
        let rotationAngle = (CGFloat.pi / 6) * translationPercent
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        let transform = translationTransform.concatenating(rotationTransform)
        
        questionView.transform = transform
        
        if translation.x > 0 {
            questionView.style = .correct
        } else {
            questionView.style = .incorrect
        }
    }
    
    private func answerQuestion() {
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        default:
            break
        }
        
        let screenWidth = UIScreen.main.bounds.width
        var translationTransform: CGAffineTransform
        if questionView.style == .correct {
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.questionView.transform = translationTransform
            self.progress.transform = CGAffineTransform(scaleX: 1, y: 4)
            self.progress.setProgress(self.progress.progress + 0.1, animated: false)
        }) { (success) in
            if success {
                self.questionView.showQuestionView()
                self.progress.transform = CGAffineTransform(scaleX: 1, y: 2)
            }
        }

        
        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            sliderView.isHidden = true
            questionView.isHidden = true
            
            if let gifV = gifView {
                    animateShowView(gifV, customDelay: 0.0)
                if (game.score > 5) {
                    gifV.loadGif(name: "bravo")
                } else {
                    gifV.loadGif(name: "wasted")
                }
            }
        }
    }
    
    private func animateShowView(_ v: UIView, customDelay: Float) {
        
        v.transform = CGAffineTransform(scaleX: 0.0, y: 2.5)
        v.isHidden = false
        UIView.animate(withDuration: 0.4, delay: TimeInterval(customDelay), usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
            v.transform = .identity
        }, completion: nil)
    }
    
    @IBAction func didTapToggleSlider(_ sender: Any) {
        sliderView.toggleSlider()
    }
    
    
    @IBAction func changeFontSize(_ sender: UISlider) {
        let fSize = CGFloat(sender.value)
        questionView.setFontSize(fSize)
    }
   
    
    @IBAction func didTapNewGame() {
        if let gifV = gifView{
            gifV.image = nil
        }
        
        setUpNewGame()
    }
    
 }

