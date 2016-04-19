class Shorturl < ActiveRecord::Base

	attr_accessor :full

	validates :longurl, presence: true

	after_create :compute_short_and_save!

	scope :unexpired, -> { where("expires_at > ?", Time.now) }

	def shortlink!(request)
    	self.shorturl =  request.protocol + domain(request) + '/go/' + self.shorturlkey
    	self.save!
    end

    def domain(request)
    	request.domain == 'localhost' ? (request.domain + ':' + request.port.to_s) : request.domain
    end 

  private
    def compute_short_and_save!
      	self.shorturlkey = (self.id + 1305).to_s(36)
      	self.save!
    end
    
end