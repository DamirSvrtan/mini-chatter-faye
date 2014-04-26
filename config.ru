require 'faye'
require 'pry-debugger'
require 'slim'
Faye::WebSocket.load_adapter('thin')

MOUNT_POINT = '/faye'

FayeApp = Faye::RackAdapter.new(:mount => MOUNT_POINT)

class DisconnectionPublisher
  def incoming(message, callback)
    if message['channel'] == '/meta/disconnect'
      client = Faye::Client.new('http://localhost:9292/faye')
      client.publish('/disconnection', username: message['username'])
    end

    callback.call(message)
  end
end

FayeApp.add_extension(DisconnectionPublisher.new)

class ChatApp
  def self.call(env)
    if env['PATH_INFO'] =~ /^#{MOUNT_POINT}/
      FayeApp.call(env)
    else
      [200, {"Content-Type" => "text/html"}, [Slim::Template.new('index.slim').render]]
    end
  end
end

run ChatApp