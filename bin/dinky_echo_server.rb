require 'socket'
require 'webrick/httprequest'
require 'webrick/httpresponse'
require 'webrick/config'
require 'json'

def log(msg)
  puts(msg)
end

server = TCPServer.open(8080)
loop {
  client = server.accept
  request = WEBrick::HTTPRequest.new(WEBrick::Config::HTTP)
  request.parse(client)

  payload = ""
  if (request.query.has_key?("payload")) then
    payload =  "\n\nPAYLOAD:\n" + JSON.pretty_generate(JSON.parse(request.query["payload"]))
  end
  log_msg = <<-RESPONSE
REQUEST RECEIVED:
-----------------------------------------------------------------------
#{request.to_s.strip}#{payload}
-----------------------------------------------------------------------
  RESPONSE

  log(log_msg)

  response = WEBrick::HTTPResponse.new(WEBrick::Config::HTTP)
  response.body = log_msg
  response.send_response(client)
  client.close()
}