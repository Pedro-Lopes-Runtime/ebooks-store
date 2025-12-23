class EbooksController < ApplicationController
  before_action :set_ebook, only: [ :show, :edit, :update, :destroy, :update_status, :preview, :purchase ]

  def index
    @sellers = User.seller.reject { |user| user.ebooks.blank? }.map { |user| [ user.name, user.id ] }
    query, filters = get_query_and_filters
    @ebooks = Ebook.published

    if filters.present?
      filters.each do |key, value|
        if key == :tag
          @ebooks = Tag.find_by(id: value).ebooks.merge(@ebooks)
        else
          @ebooks = @ebooks.where(key => value)
        end
        break if @ebooks.blank?
      end
    end

    if @ebooks.present? && query.present?
      @ebooks = @ebooks.where("title like :query OR description like :query", query: "%#{query}%")
    end

    @ebooks = @ebooks.paginate(page: params[:page] || 1, per_page: 10)
  end

  def show
    @ebook.ebook_statistic.update_visits
  end

  def new
    @ebook = Ebook.new
  end

  def create
    @ebook = Ebook.new(ebook_params)
    @ebook.tags = Tag.where(id: params[:ebook][:tags])
    if @ebook.save
      @statistics = EbookStatistic.create(ebook: @ebook)
      redirect_to @ebook
    else
      render "new", status: 422
    end
  end

  def edit
    redirect_to root_path, alert: "You do not have permission to edit this ebook" if @ebook.user != current_user
  end

  def update
    @ebook.tags = Tag.where(id: params[:ebook][:tags])
    if @ebook.update(ebook_params)
      redirect_to @ebook
    else
      render "edit", status: 422
    end
  end

  def destroy
    @ebook.destroy
  end

  def update_status
    @ebook.status = @ebook.status_before_type_cast + 1
    @ebook.save
    redirect_back_or_to "/"
  end

  def preview
    @ebook.ebook_statistic.update_preview_views
    redirect_to rails_blob_path(@ebook.preview, dispostion: "preview")
  end

  def purchase
    Thread.current[:request] = { ip: request.remote_ip, browser: Browser.new(request.user_agent).name, location: request.location.country }
    begin
      ActiveRecord::Base.transaction do
        raise ActiveRecord::Rollback if @current_user.balance < @ebook.price

        Purchase.create(user: @current_user, ebook: @ebook, price: @ebook.price)
        @ebook.user.deposit(@ebook.price/10)
        @current_user.pay(@ebook.price)
      end
    rescue
      flash[:alert] = "An error occurred and the purchase could not be completed. Please try again later"
      return redirect_back_or_to "/"
    end

    redirect_to ebooks_path, notice: "Ebook was successfully purchased."
  end

  private

  def set_ebook
    @ebook = Ebook.find(params[:id])
  end

  def ebook_params
    params.require(:ebook).permit(:title, :description, :author_id, :status, :preview, :user_id, :price, :cover)
  end

  def get_query_and_filters
    filters = {}
    filters[:tag] = params["tag"] if params["tag"].present?
    filters[:user_id] = params["user"] if params["user"].present?
    filters[:author_id] = params["author"] if params["author"].present?

    query = ""
    query = params["query"] if params["query"].present?

    [ query, filters ]
  end
end
