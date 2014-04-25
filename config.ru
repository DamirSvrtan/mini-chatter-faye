require 'faye'
require 'pry-debugger'
Faye::WebSocket.load_adapter('thin')
bayeux = Faye::RackAdapter.new(:mount => '/faye')

bayeux.on(:handshake) do |client_id|
  puts "Handshaking. Client ID: #{client_id}."
end

bayeux.on(:subscribe) do |client_id, channel|
  puts "Subscribing. Client ID: #{client_id}. Channel: #{channel}"
end

bayeux.on(:unsubscribe) do |client_id, channel|
  puts "Unsubscribing. Client ID: #{client_id}. Channel: #{channel}"
end

bayeux.on(:publish) do |client_id, channel, data|
  puts "Publishing. Client ID: #{client_id}. Channel: #{channel}. Data: #{data}."
end

bayeux.on(:disconnect) do |client_id|
  puts "Disconnecting. Client ID: #{client_id}."
end

run bayeux