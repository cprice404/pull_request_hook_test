require 'socket'
require 'webrick/httprequest'
require 'webrick/httpresponse'
require 'webrick/config'

def log(msg)
  puts(msg)
end

server = TCPServer.open(8080)
loop {
  client = server.accept
  request = WEBrick::HTTPRequest.new(WEBrick::Config::HTTP)
  request.parse(client)
  log_msg = <<-RESPONSE
REQUEST RECEIVED:
-----------------------------------------------------------------------
#{request.to_s.strip}
-----------------------------------------------------------------------
  RESPONSE

  log(log_msg)

  response = WEBrick::HTTPResponse.new(WEBrick::Config::HTTP)
  response.body = log_msg
  response.send_response(client)
  client.close()
}