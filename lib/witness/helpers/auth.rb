module Witness
  module Helpers
    module Auth
      def valid_access_token
        Witness.config('access_tokens').include?(params[:access_token])
      end

      def protected!
        redirect '/api/auth/failure' unless valid_access_token
      end
    end
  end
end
