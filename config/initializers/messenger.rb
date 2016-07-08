Messenger.configure do |config|
  config.verify_token      = 'romainwagon' #will be used in webhook verifiction
  config.page_access_token = 'EAACHLkYsI10BAK36AcNnZAzZBQ7s2aLB8sHdZAhmrcJSEuViLX1KRi1PWI41BeIvBPC2b07oOZAZAtwVQnXFVfrNSdYPNhch02TDUKK6qHI6ZCNJCJGMcsxPqFowUPqZAcj5L1s2qwimP0N9vg5cbIO2F3aI2IIdwT9QIeMzl0vZAQZDZD'
end

if fb_params.first_entry.callback.message?
  Messenger::Client.send( Messenger::Request.new( Messenger::Elements::Text.new(text: "Echo: #{fb_params.first_entry.callback.text}"), fb_params.first_entry.sender_id ) )
end
