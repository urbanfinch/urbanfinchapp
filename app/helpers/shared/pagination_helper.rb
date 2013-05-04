module Shared::PaginationHelper
  
  def pagination_visible?(objects, search)
    search.total > objects.per_page
  end
  
  def pagination_info(objects, search)
    start = (objects.current_page * objects.limit_value) - (objects.per_page - 1)
    finish = objects.current_page * objects.limit_value
    total = search.total
    
    if finish > total
      finish = total
    end
    
    if start > finish
      start = finish
    end
    
    "#{start} - #{finish} of #{total}"
  end
end