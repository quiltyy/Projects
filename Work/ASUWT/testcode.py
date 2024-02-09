import tweepy
import csv
from urlextract import URLExtract
from textblob import TextBlob

consumer_key = 'KEY'
consumer_secret = 'KEY'
access_token = 'KEY'
access_token_secret = 'KEY'

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)

public_tweets = api.search('Trump')

with open('twitter_sentiment_analysis.csv', 'w', encoding="utf-8", newline='') as output:
    fileOut = csv.writer(output)
    data = [['Tweets', 'Polarity', 'Subjectivity', 'URL']]

    fileOut.writerows(data)

    for tweet in public_tweets:
        analysis = TextBlob(tweet.text)
        polarity = analysis.sentiment.polarity
        subjectivity = analysis.sentiment.subjectivity


        url = None

        words = tweet.text.split()

        link = URLExtract()

        urls = link.find_urls(tweet.text)

        for word in words:
            # print (word)
            if 'http' in word:
                url = word

        fileOut.writerow([tweet.text, polarity, subjectivity, url])

        print(tweet.text)
        print('Polarity: ', polarity)
        print('Subjectivity:', subjectivity)