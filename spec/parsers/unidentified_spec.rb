require "spec_helper"
require_relative "../../app/models/parsers/unidentified"

RSpec.describe Parsers::Unidentified do
  it "#able?" do
    expect(Parsers::Unidentified.instance.able?("**.**")).to be true
    expect(Parsers::Unidentified.instance.able?("file.rb")).to be true
    expect(Parsers::Unidentified.instance.able?("file.js")).to be true
    expect(Parsers::Unidentified.instance.able?("file.py")).to be true
  end

  it "#extract?" do
    expect(Parsers::Unidentified.instance.extract).to eql []
  end
end
