require 'rubygems'
require 'sinatra'
require 'twilio-ruby'

#
# メッセージを再生する
#
get '/hello-twilio' do
  Twilio::TwiML::Response.new do |r|
    r.Gather :numDigits => '1', :action => '/hello-monkey/handle-gather', :method => 'get' do |g|
      g.Say 'こんにちは！'
      g.Say '音声を録音する場合は1, '
      g.Say 'なにもしない場合は2を押してください...'
    end
  end.text
end

#
# 押されたボタンを判断する
#
get '/hello-twilio/handle-gather' do
  pushed_key = params['Digits']
  # 1, 2以外のボタンが押された場合はもう一度メッセージを入力させる
  redirect '/hello-twilio/handle-gather' unless [1, 2].include?(params['Digits'])

  if pushed_key == '1'
    r.Say 'ピー！と言う発信音の後にテキトーに喋ってください...ピー！'
    r.Record :maxLength => '30', :action => '/hello-twilio/handle-record', :method => 'get'
  elsif pushed_key == '2'
    r.Say 'サヨナラ！'
  end
end

#
# 録音したメッセージを再生する
#
get '/hello-twilio/handle-record' do
  r.Say '録音したメッセージを再生します！'
  r.Play params['RecordingUrl']
  r.Say 'サヨナラ！'
end
