module ApplicationHelper

  def title
    [@title, yield(:title), t(:site_name)].reject(&:blank?).join(' - ')
  end

end
