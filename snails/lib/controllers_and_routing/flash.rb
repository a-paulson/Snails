require 'json'

class Flash
  attr_accessor :now

  def initialize(req)
    cookie = req.cookies['_snails_app_flash']
    @now = (cookie ? JSON.parse(cookie) : {})
    @flash = {}
  end

  def [](key)
    @flash.merge(@now)[key]
  end

  def []=(key, val)
    @flash[key] = val
  end

  def store_flash(res)
    res.set_cookie('_snails_app_flash', value: @flash.to_json, path: '/')
  end
end
