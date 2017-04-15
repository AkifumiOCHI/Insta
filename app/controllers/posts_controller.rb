class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only:[:edit, :update, :destroy, :show]

   def index
     @posts = Post.all
   end

   def new
     @post = Post.new
   end

   def create
     @post = Post.new(posts_params)
     @post.user_id = current_user.id
     if @post.save
       redirect_to posts_path, notice: 'Posts Succeed!'
       NoticeMailer.sendmail_post(@post).deliver
     else
       render 'new'
     end
   end

   def edit
     @post = Post.find(params[:id])
   end

   def update
     @post = Post.find(params[:id])
     if @post.update(posts_params)
       redirect_to posts_path, notice: 'Posts Updated!'
     else
       render 'edit'
     end
   end

   def destroy
     @post.destroy
     redirect_to posts_path, notice: 'Posts Deleted!'
   end

   def show
     @post = Post.find(params[:id])
   end

private
   def posts_params
     params.require(:post).permit(:title, :content)
   end

   def set_post
     @post = Post.find(params[:id])
   end
end
