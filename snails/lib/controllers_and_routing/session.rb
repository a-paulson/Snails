require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    if req.cookies['_snails_app']
      @session = JSON.parse(req.cookies['_snails_app'])
    else
      @session = {}
    end
  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    @session[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie('_snails_app', value: @session.to_json, path: '/')
  end
end
