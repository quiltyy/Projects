const makeDeck = () => {
    return {
        deck: [],
        drawnCards: [],
        suits: ['hearts', 'spades', 'clubs', 'diamonds'],
        values: '2,3,4,5,6,7,8,9,10,J,Q,K,A',
        insitalizeDeck() {
            const {
                suits,
                values,
                deck
            } = this;
            for (let value of values.split(',')) {
                for (let suit of suits) {
                    deck.push({
                        values: values,
                        suit: suit
                    })
                }
            }

        },
        drawCard() {
            // draw a single card from the top of the deck
            const card = this.deck.pop();
            this.drawnCards.push(card);
            return card;
        },
        drawMultiple(numCards) {
            // select a number of cards from the top of the deck
            const cards = [];
            for (let i = 0; i < numCards; i++) {
                cards.push(this.drawCard());
            }
            return cards;
        },
        shuffle() {
            const {
                deck
            } = this;
            //loop over deck backwards
            for (let i = deck.length - 1; i > 0; i--) {
                //pick rnadom index beflore current element
                let j = Math.floor(Math.random() * (i + 1));
                // swap
                [deck[i], deck[j]] = [deck[j], deck[i]];
            }

        }
    }
}

const myDeck = makeDeck();
myDeck.insitalizeDeck();
myDeck.shuffle();
const hand1 = myDeck.drawMultiple(2);
const hand2 = myDeck.drawMultiple(2);
const dealer1 = myDeck.drawMultiple(5);

const deck2 = makeDeck();
deck2.insitalizeDeck();