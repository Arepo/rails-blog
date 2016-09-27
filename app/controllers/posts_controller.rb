class PostsController < ApplicationController
  before_action :resolve_topic, only: [:create, :update]
  around_action :proceed_if_logged_in, only: [:create, :update, :destroy]

  def index
    # TODO enable filtering by multiple tags
    # TODO enable deselecting tag(s)
    @posts = Post.all.order("Lower(title)")
    @tags = Tag.names
    @topics = PostDisplayDecorator.render_multiple Post.topics
  end

  def filter_posts
    @tag = params[:tag]
    @post_ids = Post.tagged_with(params[:tag]).pluck(:id)

    respond_to do |format|
      format.js
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    co_author = Author.find_by id: params[:authors]["co-author"]
    @post.authors << [current_user, co_author].compact

    if @post.save
      tags.each { |tag| Tag.with_name(tag).first_or_create.posts << @post }
      redirect_to post_path(@post)
    else
      render 'new'
    end
  end

  def show
    @post = Post.friendly.find(params[:id]).wrap

    if request.path != post_path(@post)
      redirect_to @post, status: :moved_permanently, only_path: true
    end
  end

  def edit
    @post = Post.friendly.find(params[:id])
  end

  def update
    # TODO Enable updating authors
    # TODO Delete tags when they're no longer in use
    @post = Post.friendly.find(params[:id])

    if @post.update_post_and_tags(post_params: post_params, tag_params: params[:tags])
      redirect_to post_path(@post)
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.friendly.find params[:id]
    @post.destroy

    redirect_to '/', notice: "#{@post.title} has been deleted"
  end

  private

  def post_params
    @post_params ||= params.require(:post).permit(:title, :body, :topic, :new_topic)
  end

  def proceed_if_logged_in
    if current_user
      yield
    end
  end

  def resolve_topic
    # TODO use JS to ensure params can't include both topic and new topic
    topic = post_params.delete(:new_topic)
    post_params[:topic] = topic if topic.present?
  end

  def tags
    @post.extract_tags(params[:tags])
  end
end
