require 'faye'
require 'pry-debugger'
require 'slim'
Faye::WebSocket.load_adapter('thin')

MOUNT_POINT = '/faye'

Bayeux = Faye::RackAdapter.new(:mount => MOUNT_POINT)

Bayeux.on(:handshake) do |client_id|
  puts "Handshaking. Client ID: #{client_id}."
end

Bayeux.on(:subscribe) do |client_id, channel|
  puts "Subscribing. Client ID: #{client_id}. Channel: #{channel}"
  # client = Faye::Client.new('http://localhost:9292/faye')
  # client.publish('/chat', 'username' => client_id, 'text' => 'Hello world')
end

Bayeux.on(:unsubscribe) do |client_id, channel|
  puts "Unsubscribing. Client ID: #{client_id}. Channel: #{channel}"
  # client = Faye::Client.new('http://localhost:9292/faye')
  # client.publish('/unsubscription', 'username' => client_id, 'text' => 'Hello world')
end

Bayeux.on(:publish) do |client_id, channel, data|
  puts "Publishing. Client ID: #{client_id}. Channel: #{channel}. Data: #{data}."
end

Bayeux.on(:disconnect) do |client_id|
  puts "Disconnecting. Client ID: #{client_id}."
end
class ServerAuth
  def incoming(message, callback)
    # Let non-subscribe messages through
    # unless message['channel'] == '/meta/subscribe'
    #   return callback.call(message)
    # end

    if message['channel'] == '/meta/disconnect'
      client = Faye::Client.new('http://localhost:9292/faye')
      client.publish('/user_disconnection', 'username' => message['username'])
    end

    # # Get subscribed channel and auth token
    # subscription = message['subscription']
    # msg_token    = message['ext'] && message['ext']['authToken']

    # # Find the right token for the channel
    # @file_content ||= File.read('./tokens.json')

    # registry = JSON.parse(@file_content)
    # token    = registry[subscription]

    # # Add an error if the tokens don't match
    # if token != msg_token
    #   message['error'] = 'Invalid subscription auth token'
    # end

    # Call the server back now we're done
    callback.call(message)
  end
end

Bayeux.add_extension(ServerAuth.new)

# binding.pry
class DupDam
  def self.call(env)
    if env['PATH_INFO'] =~ /^#{MOUNT_POINT}/
      Bayeux.call(env)
    else
      [200, {"Content-Type" => "text/html"}, [Slim::Template.new('index.slim').render]]
    end
  end
end

run DupDam