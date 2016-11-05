module ApplicationHelper
  def full_title(page_title)
    base_title = t(:title)
    if page_title.empty?
      base_title
    else
      page_title + " - " + base_title
    end
  end
  
  def private_namespace?
    controller.class.parent.name == "Private"
  end
end
