module Api
	module V1
		class UsersController < Api::V1::BaseController
			include DeviseTokenAuth::Concerns::SetUserByToken

      def index
      end

      def show
      end



			def me
				render json: { id: current_user.id, email: current_user.email }
			end


		end
	end
end
