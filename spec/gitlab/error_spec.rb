require "spec_helper"

describe Gitlab::Error do
  describe "#handle_message" do
		require "stringio"

    before do
      request_object  = HTTParty::Request.new(Net::HTTP::Get, '/')
      response_object = Net::HTTPOK.new('1.1', 200, 'OK')
      body = StringIO.new("{foo:'bar'}")
      def body.message; self.string; end

      parsed_response = lambda { body }
      response_object['last-modified'] = Date.new(2010, 1, 15).to_s
      response_object['content-length'] = "1024"

      response = HTTParty::Response.new(request_object, response_object, parsed_response, body: body)
      @error = Gitlab::Error::ResponseError.new(response)

      @array = Array.new(['First message.', 'Second message.'])
      @obj_h = Gitlab::ObjectifiedHash.new(user: ['not set'],
                                           password: ['too short'],
                                           embed_entity: { foo: ['bar'], sna: ['fu'] })
    end

    context "when passed an ObjectifiedHash" do
      it "should return a joined string of error messages sorted by key" do
        expect(@error.send(:handle_message, @obj_h)).to eq("'embed_entity' (foo: bar) (sna: fu), 'password' too short, 'user' not set")
      end
    end

    context "when passed an Array" do
      it "should return a joined string of messages" do
        expect(@error.send(:handle_message, @array)).to eq("First message. Second message.")
      end
    end

    context "when passed a String" do
      it "should return the String untouched" do
        error = 'this is an error string'
        expect(@error.send(:handle_message, error)).to eq('this is an error string')
      end
    end
  end
end
