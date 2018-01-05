// Model

import Foundation

class Concentration {
  var cards = [Card]()
  var flipCount = 0
  var score = 0
  var previouslySeenCards = Set<Int>()
  
  var indexOfOneAndOnlyOneFaceUpCard: Int?
  
  func chooseCard(at index: Int) {
    // ignore if card is already matched.
    if !cards[index].isMatched {
      // check if we have already selected one card.
      if let matchIndex = indexOfOneAndOnlyOneFaceUpCard {
        // ignore if selected card is same as first card picked.
        if(index == matchIndex) {
          return
        }
        
        // matched two cards.
        if cards[matchIndex].identifier == cards[index].identifier {
          cards[matchIndex].isMatched = true;
          cards[index].isMatched = true;
          score += 2
        } else if previouslySeenCards.contains(index) || previouslySeenCards.contains(matchIndex)  {
            score -= 1
        }
        
        cards[index].isFaceUp = true;
        indexOfOneAndOnlyOneFaceUpCard = nil;
        
        // Remeber both flipped cards to deduct points if mismatched later.
        previouslySeenCards.insert(index)
        previouslySeenCards.insert(matchIndex)
      } else {
        // flip all cards face down again.
        for flipDownIndex in cards.indices {
          if !cards[flipDownIndex].isMatched {
            cards[flipDownIndex].isFaceUp = false
          }
        }
        
        // flip only selected card back up.
        cards[index].isFaceUp = true
        indexOfOneAndOnlyOneFaceUpCard = index
      }
    }
    
    flipCount += 1
  }
  
  func newGame() {
    for index in cards.indices {
      cards[index].isMatched = false
      cards[index].isFaceUp = false
    }
    
    // reset all variables
    flipCount = 0
    score = 0
    previouslySeenCards.removeAll()
    indexOfOneAndOnlyOneFaceUpCard = nil
    
    shuffleCards()
  }
  
  func shuffleCards() {
    // make a copy of the deck and clear original deck.
    var cardsCopy = cards
    cards.removeAll()
    
    // select a random card from the deck copy, remove it from the copy and
    // insert it back into the original deck.
    while !cardsCopy.isEmpty {
      let randomIndex = Int(arc4random_uniform(UInt32(cardsCopy.count)))
      cards.append(cardsCopy.remove(at: randomIndex))
    }
  }
  
  init(numberOfCards: Int) {
    for _ in 1...numberOfCards {
      let card = Card()
      //print("\(card.identifier)")
      cards += [card, card]
    }
    
    shuffleCards()
  }
}
