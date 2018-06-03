# frozen_string_literal: true
require 'spec_helper'
require File.expand_path '../../../../helpers/unviewed_helper.rb', __FILE__

RSpec.describe 'Unviewed Chat::Messags', type: :request do
  include UnviewedHelper

  it 'should return right number of Unviewed messages (v1)' do
    # prepare
    prepare_unviewed_coun_data
    sign_in(User.find(@user1_id))

    # action
    get("chats/#{@user2_id}/messages/unviewed_count")

    check_response
    expect(json['success']).to eq(true)
    expect(json['unviewed_count']).to eq(3)
  end

  it 'should return right number of Unviewed messages (v2)' do
    # prepare
    prepare_unviewed_coun_data
    sign_in(User.find(@user2_id))

    # action
    get("chats/#{@user1_id}/messages/unviewed_count")

    check_response
    expect(json['success']).to eq(true)
    expect(json['unviewed_count']).to eq(2)
  end
end
