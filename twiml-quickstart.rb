require 'rubygems'
require 'sinatra'
require 'twilio-ruby'

get '/hello-twilio' do
  Twilio::TwiML::Response.new do |r|
    r.Say 'Hello Twilio!'
  end.text
end
