// View

import UIKit

class ViewController: UIViewController {
  lazy var game = Concentration(numberOfCards: cardCount)
  var emojiChoices: [String]!
  var cardCount: Int {
    return (cardButtons.count+1)/2
  }
  
  @IBOutlet var cardButtons: [UIButton]!
  
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var flipCountLabel: UILabel!
  @IBOutlet weak var newGameLabel: UIButton!
  
  @IBAction func touchCard(_ sender: UIButton) {
    if let cardNumber = cardButtons.index(of: sender) {
      game.chooseCard(at: cardNumber)
      updateViewFromModel()
    } else {
      
    }
  }
  
  @IBAction func newGameTouched() {
    game.newGame()
    
    emojiChoices = nil
    emoji.removeAll()
    
    selectTheme()
    updateViewFromModel()
  }
  
  func updateViewFromModel() {
    var matchedCardsCount = 0
    
    for index in cardButtons.indices {
      let button = cardButtons[index]
      let card = game.cards[index]
      
      if card.isFaceUp {
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.setTitle(emoji(for: card), for: UIControlState.normal)
      } else {
        button.backgroundColor = UIColor.black
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.setTitle("🂠", for: UIControlState.normal)
      }
      
      if card.isMatched {
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0)
        matchedCardsCount += 1
      }
    }
    
    scoreLabel.text = "Score = \(game.score)"
    flipCountLabel.text = "Flip Count = \(game.flipCount)"
    if matchedCardsCount == cardButtons.count {
      newGameLabel.titleLabel?.font = UIFont.systemFont(ofSize: 40)
    } else {
      newGameLabel.titleLabel?.font = UIFont.systemFont(ofSize: 24)
    }
  }
  
  //var emojiChoices = ["😀","😃","😄","😁","😆","😅","😂","🤣","☺️","😊","😇"]
  var themes = [
    ["😀","😃","😄","😁","😆","😅","😂","🤣","☺️","😊","😇"],
    ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐨","🐯","🦁"],
    ["🍏","🍎","🍐","🍊","🍋","🍌","🍉","🍇","🍓","🍈"],
    ["⚽️","🏀","🏈","⚾️","🎾","🏐","🏉","🎱","🏓","🏸"],
    ["🚗","🚕","🚙","🚌","🚎","🏎","🚓","🚑","🚒","🚐"],
    ["🇹🇷","🇹🇲","🇹🇨","🇹🇻","🇻🇮","🇺🇬","🇺🇸","🇻🇳","🇦🇪","🇿🇼"]
  ]
  
  var emoji = [Int:String]()
  
  func emoji(for card: Card) -> String {
    if emoji[card.identifier] == nil {
      let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
      if emojiChoices.count != 0 {
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
      }
      
    }
    
    return emoji[card.identifier] ?? "?"
  }
  
  func selectTheme() {
    if emojiChoices == nil {
      let themeChoice = Int(arc4random_uniform(UInt32(themes.count)))
      emojiChoices = themes[themeChoice]
      switch(themeChoice) {
      case 0:
        self.view.backgroundColor = UIColor(red: 0.6667, green: 0.6667, blue: 0.6667, alpha: 1.0)
      case 1:
        self.view.backgroundColor = UIColor(red: 0.5882, green: 0.5882, blue: 0.5882, alpha: 1.0)
      case 2:
        self.view.backgroundColor = UIColor(red: 0.5373, green: 0.5373, blue: 0.5373, alpha: 1.0)
      case 3:
        self.view.backgroundColor = UIColor(red: 0.4863, green: 0.4863, blue: 0.4863, alpha: 1.0)
      case 4:
        self.view.backgroundColor = UIColor.lightGray
      case 5:
        self.view.backgroundColor = UIColor.darkGray
      default:
        self.view.backgroundColor = UIColor.red
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    selectTheme()
  }
}

