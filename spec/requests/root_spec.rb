# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Root', type: :request do
  it 'works' do
    get('/')

    expect(response.code).to eq('200')
    expect(response.content_type).to eq('application/json')
    expect(json['succes']).to eq(true)
    expect(json['message']).to eq('hello')
  end
end
