

import UIKit

class QuestionView: UIView {

    @IBOutlet var questionLabel: UILabel!
    
    var title = "" {
        didSet {
            questionLabel.text = title
        }
    }
    
    enum Style {
        case correct, incorrect, standard
    }
    
    var style: Style = .standard {
        didSet {
            setStyle(style)
        }
    }
    
    private func setStyle(_ newStyle: Style)    {
        switch newStyle {
            case .correct:
                backgroundColor = #colorLiteral(red: 0.7862178683, green: 0.9157941937, blue: 0.6245151758, alpha: 1)
            case .incorrect:
                backgroundColor = #colorLiteral(red: 0.9731615186, green: 0.5310093164, blue: 0.5743476748, alpha: 1)
            case .standard:
                backgroundColor = #colorLiteral(red: 0.7465937138, green: 0.7695199251, blue: 0.788605392, alpha: 1)
        }
    }
    
    
    
    func setFontSize(_ newFontSize: CGFloat) {
        questionLabel.font = UIFont.systemFont(ofSize: newFontSize)
    }
    
    func showQuestionView() {
        self.transform = .identity
        self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        self.style = .standard
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.2, options: [], animations: {
            self.transform = .identity
        }, completion: nil)
    }
}
