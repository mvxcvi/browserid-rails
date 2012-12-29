require 'json'
require 'net/https'

module BrowserID
  module Verifier
    # Public: This class sends the assertion to Mozilla's Persona server for
    # verification.
    class Persona
      attr_accessor :server, :path

      # Public: String defining the endpoint of the server to perform Persona
      # verifications against.
      VERIFICATION_SERVER = 'verifier.login.persona.org'

      # Public: String defining the normal path to POST assertion verifications
      # to.
      VERIFICATION_PATH = '/verify'

      # Public: Constructs a new Persona verifier.
      #
      # server - Domain String of the server to send assertions to for
      #          verifications (default: VERIFICATION_SERVER).
      # path   - Path String to POST to on the server (default:
      #          VERIFICATION_PATH).
      #
      def initialize(server=VERIFICATION_SERVER, path=VERIFICATION_PATH)
        @server = server
        @path = path
      end

      # Public: Verifies a Persona assertion for a given audience.
      #
      # assertion - Persona authentication assertion.
      # audience  - Audience String to verify assertion against. This should be
      #             the URI of the service with scheme, authority, and port.
      #
      # Returns the authenticated email address String and the issuing domain
      # if the assertion is valid.
      # Raises an exception with a failure message if the client was not
      # successfully authenticated.
      #
      # Examples
      #
      #   verify(assertion, "https://app.example.com:443")
      #   # => "user@example.com", "persona.mozilla.com"
      #
      def verify(assertion, audience)
        http = Net::HTTP.new(@server, 443)
        http.use_ssl = true

        verification = Net::HTTP::Post.new(@path)
        verification.set_form_data(assertion: assertion, audience: audience)

        response = http.request(verification)
        raise "Unsuccessful response from #{@server}: #{response}" unless response.kind_of? Net::HTTPSuccess
        authentication = JSON.parse(response.body)

        # Authentication response is a JSON hash which must contain a 'status'
        # of "okay" or "failure".
        status = authentication['status']
        raise "Unknown authentication status '#{status}'" unless %w{okay failure}.include? status

        # An unsuccessful authentication response should contain a reason string.
        raise "Assertion failure: #{authentication['reason']}" unless status == "okay"

        # A successful response looks like the following:
        # {
        #   "status": "okay",
        #   "email": "user@example.com",
        #   "audience": "https://service.example.com:443",
        #   "expires": 1234567890,
        #   "issuer": "persona.mozilla.com"
        # }

        auth_audience = authentication['audience']
        raise "Persona assertion audience '#{auth_audience}' does not match verifier audience '#{audience}'" unless auth_audience == audience

        expires = authentication['expires'] && Time.at(authentication['expires'].to_i/1000.0)
        raise "Persona assertion expired at #{expires}" if expires && expires < Time.now

        [authentication['email'], authentication['issuer']]
      end
    end
  end
end
