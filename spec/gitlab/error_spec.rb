require "spec_helper"
require "stringio"

describe Gitlab::Error do
  let(:request_object)  { HTTParty::Request.new(Net::HTTP::Get, '/') }
  let(:response_object) { Net::HTTPOK.new('1.1', 200, 'OK') }
  let(:body)            { StringIO.new("{foo:'bar'}") }
  let(:parsed_response) { -> { body } }

  let(:response) do
    HTTParty::Response.new(
      request_object,
      response_object,
      parsed_response,
      body: body
    )
  end

  let(:error) { Gitlab::Error::ResponseError.new(response) }
  let(:date)  { Date.new(2010, 1, 15).to_s }

  before do
    def body.message
      string
    end

    response_object['last-modified']  = date
    response_object['content-length'] = "1024"
  end

  describe "#handle_message" do
    let(:array) { Array.new(['First message.', 'Second message.']) }
    let(:obj_h) do
      Gitlab::ObjectifiedHash.new(
        user:         ['not set'],
        password:     ['too short'],
        embed_entity: { foo: ['bar'], sna: ['fu'] }
      )
    end

    context "when passed an ObjectifiedHash" do
      it "returns a joined string of error messages sorted by key" do
        expect(error.send(:handle_message, obj_h)).
          to eq(
            "'embed_entity' (foo: bar) (sna: fu), 'password' too short, 'user' not set"
          )
      end
    end

    context "when passed an Array" do
      it "returns a joined string of messages" do
        expect(error.send(:handle_message, array)).
          to eq("First message. Second message.")
      end
    end

    context "when passed a String" do
      it "returns the String untouched" do
        error_str = 'this is an error string'

        expect(error.send(:handle_message, error_str)).
          to eq(error_str)
      end
    end
  end

  describe "#response_message" do
    it "returns the message of the parsed_response" do
      expect(error.response_message).to eq(body.string)
    end
  end
end
