require 'rubygems'
require 'sinatra'
require 'twilio-ruby'

#
# メッセージを再生する
#
get '/hello-twilio' do
  Twilio::TwiML::Response.new do |r|
    r.Gather :numDigits => '1', :action => '/hello-twilio/handle-gather', :method => 'get' do |g|
      g.Say 'こんにちは！', :language => 'ja-jp'
      g.Say '音声を録音する場合は1, ', :language => 'ja-jp'
      g.Say 'なにもしない場合は2を押してください...', :language => 'ja-jp'
    end
  end.text
end

#
# 押されたボタンを判断する
#
get '/hello-twilio/handle-gather' do
  pushed_key = params['Digits']
  # 1, 2以外のボタンが押された場合はもう一度メッセージを入力させる
  redirect '/hello-twilio' unless ['1', '2'].include? pushed_key

  if pushed_key == '1'
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'ピー！と言う発信音の後にテキトーに喋ってください。 何かキーを押すと録音を終了します。', :language => 'ja-jp'
      r.Record :maxLength => '30', :action => '/hello-twilio/handle-record', :method => 'get'
    end
  elsif pushed_key == '2'
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'サヨナラ！', :language => 'ja-jp'
    end
  end
  response.text
end

#
# 録音したメッセージを再生する
#
get '/hello-twilio/handle-record' do
  Twilio::TwiML::Response.new do |r|
    r.Say '録音したメッセージを再生します！', :language => 'ja-jp'
    r.Play params['RecordingUrl']
    r.Say 'サヨナラ！', :language => 'ja-jp'
  end.text
end
