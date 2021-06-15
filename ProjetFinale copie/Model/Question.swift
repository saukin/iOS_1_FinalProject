struct Question {
    var title = ""
    var isCorrect = false
    
    init(title: String, isCorrect: Bool) {
        self.title = title
        self.isCorrect = isCorrect
    }
    
    init() {
        self.init(title: "", isCorrect: false)
    }
}
