require 'httparty'

test_api = HTTParty.get('https://pareshchouhan-trivia-v1.p.mashape.com/v1/getAllQuizQuestions')
puts test_api
