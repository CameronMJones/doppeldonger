require 'open-uri'

class DongerString

	def self.sanitize(str)
		str.gsub(/\s+/, "").downcase
	end

	def self.encode(str)
		URI::encode(str)
	end

end