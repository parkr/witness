module ChatLogServer
  module Helpers
    module Auth
      def valid_access_token
        ChatLogServer.config('access_tokens').include?(params[:access_token])
      end

      def protected!
        redirect '/api/auth/failure' unless valid_access_token
      end
    end
  end
end
