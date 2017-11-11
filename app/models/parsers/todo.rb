require "openssl"

module Parsers
  class Todo < ClosedStruct
    class << self
      def calculate_id(filename, fields)
        OpenSSL::HMAC.hexdigest OpenSSL::Digest.new("sha1"), filename, fields.join
      end
    end

    def addition?
      /^\+/.match? line
    end

    def removal?
      /^\-/.match? line
    end

    def unique_id(filename:)
      self.class.calculate_id filename, to_h.values_at(:line_number, :line)
    end
  end
end
