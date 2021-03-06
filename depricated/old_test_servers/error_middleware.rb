require 'rack'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative  '../lib/exception_middleware'
require_relative '../views/errors/test_me'
require_relative '../lib/static_assets'

$cats = [
  { id: 1, name: "Curie" },
  { id: 2, name: "Markov" }
]

$statuses = [
  { id: 1, cat_id: 1, text: "Curie loves string!" },
  { id: 2, cat_id: 2, text: "Markov is mighty!" },
  { id: 3, cat_id: 1, text: "Curie is cool!" }
]

class StatusesController < ControllerBase
  def index
    # TestMe.throw
    raise "test test errror error"
    statuses = $statuses.select do |s|
    s[:cat_id] == Integer(params['cat_id'])
  end

    render_content(statuses.to_json, "application/json")
  end
end

class Cats2Controller < ControllerBase
  def index
    render_content($cats.to_json, "application/json")
  end
end


router = Router.new
router.draw do
  get Regexp.new("^/cats$"), Cats2Controller, :index
  get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
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
