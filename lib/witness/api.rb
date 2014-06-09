module Witness
  module Api
    ENDPOINTS = {
      "/api/auth/failure"    => 'forbidden',
      "/api/messages/log"    => 'messages_log',
      "/api/messages/latest" => 'messages_latest'
    }

    FORBIDDEN = {
      :error => {
        :message => "Forbidden",
        :code    => 403
      }
    }

    def self.escape(text)
      CGI.escapeHTML(text)
    end

    def self.can_handle?(path)
      path["/api"] && ENDPOINTS.keys.include?(path)
    end

    def self.handle(req, params)
      send(ENDPOINTS[req.path.to_s], req, params)
    end

    def self.messages_log(req, params)
      Message.new({
        room:    escape(params["room"].to_s.downcase),
        author:  escape(params["author"]),
        message: escape(params["message"]),
        at:      Time.parse(params["time"])
      }).save!
      params.delete('access_token')
      params
    end

    def self.messages_latest(req, params)
      limit = if params[:limit]
        params[:limit].to_i
      else
        10
      end
      Message.latest(limit).map(&:to_h)
    end
  end
end
