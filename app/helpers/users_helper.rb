module UsersHelper

  def link_to_twitter_profile(screen_name)
    link_to(screen_name, "http://twitter.com/#{screen_name}", :class => 'twitter-profile-link', :'data-window' => 'new')
  end

   def comma_seperated_usernames(array)
    # ['foo', 'bar', 'foobar'] becomes 'foo, bar and foobar'
    array.collect{|v| link_to_twitter_profile v}.join(', ').gsub(/,([^,]*)$/," and \\1")
  end

end
