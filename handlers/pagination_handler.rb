# frozen_string_literal: true

module PaginationHandler
  MAX_ITEMS = 50.freeze

  private

  def paginate_yeild(r, items)
    page = pagination_params(r)['page'].to_i
    per = pagination_params(r)['per_page'].to_i

    per = MAX_ITEMS if per > MAX_ITEMS || per <= 0
    page = 1 if page <= 0

    items.page(page).per(per)
  end

  def pagination_json(items)
    {
      total_pages: items.total_pages,
      current_page: items.current_page,
      next_page: items.next_page,
      prev_page: items.prev_page,
      first_page: items.first_page?,
      last_page: items.last_page?
    }
  end

  def pagination_params(r)
    r.params.slice('page', 'per_page')
  end
end
