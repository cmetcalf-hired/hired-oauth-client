module OmniAuth
  module Strategies
    class HiredAdmin < OmniAuth::Strategies::OAuth2
      option :client_options, {
        site:          Rails.configuration.hired['admin_url'],
        authorize_url: '/oauth/authorize',
        token_url:     '/oauth/token',
        me_url:        '/api/v1/me',
        ssl:           { verify: !Rails.env.development? }
      }

      uid { hired_user_info["id"] }

      info do
        {
          email: hired_user_info["email"],
          name: hired_user_info["name"],
          role: hired_user_info["role"],
          hired_type: hired_user_info["type"],
        }
      end

      def authorize_params
        super.tap do |params|
          params[:response_type]  = "code"
          params[:client_id]      = client.id
          params[:redirect_uri] ||= callback_url
        end
      end

      def build_access_token
        token_params = {
          code:          request.params['code'],
          redirect_uri:  callback_url,
          client_id:     client.id,
          client_secret: client.secret,
          grant_type:    'authorization_code'
        }
        client.get_token(token_params)
      end

      private

      def me_url
        client.options[:me_url]
      end

      # {
      #   "id" => 1,
      #   "name" => "Dwight Schrute",
      #   "email" => "dwight.schrute@example.com",
      #   "role" => "Candidate",
      #   "type" => nil
      # }
      def hired_user_info
        @hired_user_info ||= access_token.get(me_url).parsed
      end
    end
  end
end