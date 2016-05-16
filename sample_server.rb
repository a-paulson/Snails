require 'rack'
require_relative 'manifest'

router = Router.new
router.draw do
  #HTTP_method Regexp.new("^your_URL$"), your_Controller, :controller_method
  #Example:
  #get Regexp.new("^/cats$"), CatsController, :index
end


app_proc = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

app = Rack::Builder.app do
  use ExceptionMiddleware
  use StaticAsset
  run app_proc
end

Rack::Server.start(
 app: app,
 Port: 3000
)
