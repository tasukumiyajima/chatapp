module ApplicationHelper
  def full_title(page_title)
    base_title = "Simple ChatApp"
    if page_title.blank?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
