module Ckeditor
  # Simple paginate relation
  class Paginatable
    attr_reader :limit_value, :offset_value

    def initialize(scope, options = {})
      @scope = scope
      @limit_value = (options[:limit] || Ckeditor.default_per_page).to_i
    end

    def page(num = 1)
      @offset_value = limit_value * ([num.to_i, 1].max - 1)
      self
    end

    def scoped
      @scope.limit(limit_value).offset(offset_value)
    end
    alias all scoped
    alias to_a scoped

    # Next page number in the collection
    def next_page
      current_page + 1 unless last_page?
    end

    # Previous page number in the collection
    def prev_page
      current_page - 1 unless first_page?
    end

    # First page of the collection?
    def first_page?
      current_page == 1
    end

    # Last page of the collection?
    def last_page?
      current_page >= total_pages
    end

    # Total number of pages
    def total_pages
      (total_count.to_f / limit_value).ceil
    end

    # total item numbers of scope
    def total_count
      @total_count ||= @scope.count
    end

    # Current page number
    def current_page
      offset = (offset_value < 0 ? 0 : offset_value)
      (offset / limit_value) + 1
    end
  end
end
