class BlogController < ApplicationController
  def index
    @posts = BlogPost.all
  end

  def show
    @post = BlogPost.find(params[:slug])
    return redirect_to blog_path, alert: "Article not found." unless @post
  end
end
