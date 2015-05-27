require 'rails_helper'

RSpec.describe Metro::Connection do
  subject { Metro::Connection }

  it 'gets data from a URL' do
    expect(subject.get('https://teamgaslight.com/')).to include('Made with love in')
  end
end
