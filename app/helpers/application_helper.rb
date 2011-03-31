module ApplicationHelper

  def title
    [@title, yield(:title), t(:site_name)].reject(&:blank?).join(' - ')
  end

  def I81n_link(phrase, link_phrase, link_url = '', html_attributes = {})
    t(phrase, :link => link_to(t(":#{link_phrase}"), link_url, html_attributes))
  end

end
