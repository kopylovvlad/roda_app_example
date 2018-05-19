# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Auth', type: :request do
  it 'return empty json' do
    get('/awesome/long/fake/path')
    expect(response.code).to eq('404')
    expect(response.content_type).to eq('application/json')
    expect(json).to eq({})
  end
end
