require 'rails_helper'
require 'protocol_buffers'

RSpec.describe Metro::RealtimeProtobuf do
  let(:fixture) { File.read('spec/fixtures/realtime_updates.buf') }
  let(:url) { "http://example.com/realtime_update_url" }
  subject { Metro::RealtimeProtobuf }

  before do
    Rails.cache.clear
    allow(Metro::Connection).to receive(:get).with(url).and_return(fixture)
  end

  describe ".fetch" do
    it "fetches the buffer and parses into a hash" do
      expect(subject.fetch(url)).to have_key(:entity)
    end

    context "when called multiple times" do
      before do
        subject.fetch(url)
        subject.fetch(url)
      end

      it "caches the result" do
        expect(Metro::Connection).to have_received(:get).once
      end
    end

    context 'with an invalid feed' do
      before do
        expect(TransitRealtime::FeedMessage).to receive(:parse).and_raise(ProtocolBuffers::DecodeError)
      end

      it 'throws a Metro::Error' do
        expect { subject.fetch(url) }.to raise_error(Metro::Error)
      end
    end
  end
end
