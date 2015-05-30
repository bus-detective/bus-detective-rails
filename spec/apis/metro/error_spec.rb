require 'rails_helper'

RSpec.describe Metro::Error do
  subject do
    begin
      begin
        raise Error
      rescue
        raise Metro::Error.new "Testing"
      end
    rescue => e
      e
    end
  end

  it 'has a message' do
    expect(subject.message).to eq("Testing")
  end

  it 'has a cause' do
    expect(subject.cause).not_to be_nil
  end
end

