require 'spec_helper'

describe Gitlab::FileResponse do
  before do
    @file_response = Gitlab::FileResponse.new StringIO.new("", 'rb+')
  end

  context '.parse_headers!' do
    it "should parse headers" do
      @file_response.parse_headers!('Content-Disposition' => "attachment; filename=artifacts.zip")
      expect(@file_response.filename).to eq "artifacts.zip"
    end
  end
end
