Messenger.configure do |config|
  config.verify_token      = 'romainwagon' #will be used in webhook verifiction
  config.page_access_token = 'EAACHLkYsI10BAK36AcNnZAzZBQ7s2aLB8sHdZAhmrcJSEuViLX1KRi1PWI41BeIvBPC2b07oOZAZAtwVQnXFVfrNSdYPNhch02TDUKK6qHI6ZCNJCJGMcsxPqFowUPqZAcj5L1s2qwimP0N9vg5cbIO2F3aI2IIdwT9QIeMzl0vZAQZDZD'
end

unless Rails.env.production?
  Dir["#{Rails.root}/app/bot/**/*.rb"].each { |file| require file }
end

require 'facebook/messenger'

Facebook::Messenger.configure do |config|
  config.access_token = ENV['ACCESS_TOKEN']
  config.verify_token = ENV['VERIFY_TOKEN']
end

include Facebook::Messenger

Bot.on :message do |message|
  puts "Received #{message.text} from #{message.sender}"

  case message.text
  when /hello/i
    Bot.deliver(
      recipient: message.sender,
      message: {
        text: 'Hello, human!'
      }
    )
  when /something humans like/i
    Bot.deliver(
      recipient: message.sender,
      message: {
        text: 'I found something humans seem to like:'
      }
    )

    Bot.deliver(
      recipient: message.sender,
      message: {
        attachment: {
          type: 'image',
          payload: {
            url: 'https://i.imgur.com/iMKrDQc.gif'
          }
        }
      }
    )

    Bot.deliver(
      recipient: message.sender,
      message: {
        attachment: {
          type: 'template',
          payload: {
            template_type: 'button',
            text: 'Did human like it?',
            buttons: [
              { type: 'postback', title: 'Yes', payload: 'HUMAN_LIKED' },
              { type: 'postback', title: 'No', payload: 'HUMAN_DISLIKED' }
            ]
          }
        }
      }
    )
  else
    Bot.deliver(
      recipient: message.sender,
      message: {
        text: 'You are now marked for extermination.'
      }
    )

    Bot.deliver(
      recipient: message.sender,
      message: {
        text: 'Have a nice day.'
      }
    )
  end
end

Bot.on :postback do |postback|
  case postback.payload
  when 'HUMAN_LIKED'
    text = 'That makes bot happy!'
  when 'HUMAN_DISLIKED'
    text = 'Oh.'
  end

  Bot.deliver(
    recipient: postback.sender,
    message: {
      text: text
    }
  )
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
