---
layout: post
title: "github�� jekyll �׸� ����ؼ� DS�� ��α� ����" 
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