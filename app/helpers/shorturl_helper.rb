module ShorturlHelper

	def link_short(url)
	    link = go_urls_url(url.short)
	    content_tag(:a, link, {
	      'href' => link,
	      'target' => '_blank',
	    })
  	end
end