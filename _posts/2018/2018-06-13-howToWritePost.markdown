---
layout: post
title: 글 쓰는 방법 
category: github 
tags: [github, jekyll]
no-post-nav: true
---

test

{% highlight ruby %}
def show
  @widget = Widget(params[:id])
  respond_to do |format|
    format.html # show.html.erb
    format.json { render json: @widget }
  end
end
{% endhighlight %}