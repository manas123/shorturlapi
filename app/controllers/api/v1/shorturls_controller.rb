module Api
	module V1
		class ShorturlsController < ApplicationController
			skip_before_filter :verify_authenticity_token

			def index
    			@shorturls = Shorturl.unexpired.all
    			respond_to do |format|
              		format.json { render text: @shorturls.last.to_json }
            	end
  			end

			def create
				puts request.original_url
				puts request.host
				puts request.port
				puts request.fullpath
				puts request.domain
				puts request.protocol
				@request_obj = request
				expires_at =  params[:expire_date] || (Time.now + 1.days)
				attributes = {
					longurl: params[:url],
					expires_at: expires_at
				}
				@shorturl_obj = Shorturl.unexpired.where(longurl: params[:url]).first
				if @shorturl_obj.blank?
					Shorturl.create!(attributes)
					@shorturl_obj = Shorturl.where(longurl: params[:url]).last
					@shorturl_obj.shortlink!(request)
					Rails.cache.write(@shorturl_obj.shorturlkey, @shorturl_obj.longurl , expires_in: 1.days)
				end
				respond_to do |format|
			      if @shorturl_obj.id || @shorturl_obj.save
			        format.json { render json: @shorturl_obj.to_json }
			      else
			        format.json { render json: @shorturl_obj.errors, status: :unprocessable_entity }
			      end
			    end
			end

			def show
				@shorturl_obj = Shorturl.find_by(id: params[:id])
			    if(@shorturl_obj.nil?)
			      	respond_to do |format|
			        	format.json { head :no_content }
			      	end
			    else
			    	respond_to do |format|
			        	format.json { render json: @shorturl_obj.to_json }
			      	end
			    end
			end

			def go
				puts "--------------------------------hello------------------"
				puts "---------#{request}---------"
				@longurl = Rails.cache.fetch(params[:shorturlkey])
				if @longurl.blank?
					puts "...........querying from db ........"
			    	@shorturl_obj = Shorturl.unexpired.where(shorturlkey: params[:shorturlkey]).first
			    	@longurl = @shorturl_obj.longurl if @shorturl_obj
			    end
			    if (@longurl.blank?)

			      	hash = {
			      		status: "failure",
			      		error: "Url has been expired / Unable to find the redirect"
			      	}
			      	respond_to do |format|
              			format.json { render text: hash.to_json}
            		end
			    else
			      redirect_to @longurl
			    end
			end

		end
	end
end