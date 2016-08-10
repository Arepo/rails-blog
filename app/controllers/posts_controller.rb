class PostsController < ApplicationController
  def index
    @topics = Post.topics
  end

  def new
    @post = Post.new
  end

  def create
    # TODO use JS to ensure params can't include both topic and new topic
    topic = post_params.delete(:new_topic)
    post_params[:topic] = topic if topic.present?

    @post = Post.new(post_params)

    if @post.save
      redirect_to post_path(@post)
    else
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])

    @post.destroy
    redirect_to '/'
  end

  private

  def post_params
    @post_params ||= params.require(:post).permit(:title, :body, :topic, :new_topic)
  end
end
