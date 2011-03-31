module UsersHelper

  def link_to_twitter_profile(screen_name)
    link_to(screen_name, "http://twitter.com/#{screen_name}", :class => 'twitter-profile-link', :'data-window' => 'new')
  end

   def comma_seperated_usernames(array)
#   return array unless array.is_a? Array # best line ever
    array.collect{|v| link_to_twitter_profile v}.join(', ').gsub(/,([^,]*)$/," and \\1")
  end

  def undo_href(method, names)
    href = '?method='
    href += (method == 'follow') ? 'unfollow' : 'follow'
    href += '&users='
    href += names.join('+')
  end

end
