function makeDeck() {
    const deck = [];
    const suits = ['hearts', 'spades', 'clubs', 'diamonds'];
    const values = '2,3,4,5,6,7,8,9,10,J,Q,K,A';
    for (let value of values.split(',')) {
        for (let suit of suits) {
            deck.push({
                values: values,
                suit: suit
            })
        }
    }
    return deck;
}

function drawCard(deck) {
    return deck.pop()
}

const myDeck = {
    deck: [],
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
        return this.deck.pop()
    }
}