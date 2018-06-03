# frozen_string_literal: true
require 'spec_helper'
require File.expand_path '../../../helpers/unviewed_helper.rb', __FILE__

RSpec.describe 'Messages::UnviewedCountService', type: :model do
  include UnviewedHelper

  it 'should return right number of Unviewed messages (v1)' do
    prepare_unviewed_coun_data

    count = Messages::UnviewedCountService
      .perform(@chat, @user1_id)

    expect(count).to eq(3)
  end

  it 'should return right number of Unviewed messages (v2)' do
    prepare_unviewed_coun_data

    count = Messages::UnviewedCountService
      .perform(@chat, @user2_id)

    expect(count).to eq(2)
  end
end
