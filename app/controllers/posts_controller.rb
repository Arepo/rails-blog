class PostsController < ApplicationController
  before_action :resolve_topic, only: [:create, :update]

  def index
    @tags = Tag.names
    @topics = Post.topics
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      tags.each { |tag| Tag.where(name: tag).first_or_create.posts << @post }
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

  def resolve_topic
    # TODO use JS to ensure params can't include both topic and new topic
    topic = post_params.delete(:new_topic)
    post_params[:topic] = topic if topic.present?
  end

  def post_params
    @post_params ||= params.require(:post).permit(:title, :body, :topic, :new_topic)
  end

  def tags
    tags = params[:tags].select { |k,v| v == '1' }.to_a
    new_tags = params[:tags][:new_tags].split(',').map(&:strip)
    tags | new_tags
  end
end
