---
layout: post
title: "github에 jekyll 테마 사용해서 DS랩 블로그 생성" 
category: github 
tags: [github, jekyll]
---

{% highlight ruby %}
def show
  @widget = Widget(params[:id])
  respond_to do |format|
    format.html # show.html.erb
    format.json { render json: @widget }
  end
end
{% endhighlight %}