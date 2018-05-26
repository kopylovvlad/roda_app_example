# frozen_string_literal: true

class ServiceAnswer
  attr_reader :item, :errors

  def initialize(success = false, item = nil, errors = {})
    @success = success
    @item = item
    @errors = errors
  end

  def success?
    @success == true
  end
end
