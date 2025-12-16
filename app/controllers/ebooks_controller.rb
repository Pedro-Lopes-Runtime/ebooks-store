class EbooksController < ApplicationController
  before_action :set_ebook, only: [ :show, :edit, :update, :destroy, :update_status, :preview, :purchase ]

  def index
    @sellers = Seller.all.reject { |user| user.ebooks.blank? }.map(&:user).map { |user| [ user.name, user.id ] }
    query, filters = get_query_and_filters
    @ebooks = Ebook.all

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
    stats = @ebook.ebook_statistic
    stats.visits += 1
    stats.save
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
    case @ebook.ebook_status.name
    when "Draft"
      @ebook.ebook_status = EbookStatus.find_by(name: "Pending")
    when "Pending"
      @ebook.ebook_status = EbookStatus.find_by(name: "Live")
    end
    @ebook.save
    redirect_back_or_to "/"
  end

  def preview
    stats = @ebook.ebook_statistic
    stats.preview_views += 1
    stats.save
    redirect_to rails_blob_path(@ebook.preview, dispostion: "preview")
  end

  def purchase
    buyer = Buyer.first

    begin
      ActiveRecord::Base.transaction do
        raise ActiveRecord::Rollback if buyer.user.balance < @ebook.price

        Purchase.create(buyer: buyer, ebook: @ebook, price: @ebook.price)
        @ebook.ebook_statistic.update_purchases
        @ebook.seller.user.deposit(@ebook.price/10)
        buyer.user.pay(@ebook.price)
      end
    rescue
      flash[:alert] = "An error occurred and the purchase could not be completed. Please try again later"
      return redirect_back_or_to "/"
    end

    @ebook.ebook_statistic.visitor_statistics.create(ip: request.remote_ip, browser: Browser.new(request.user_agent).name, location: request.location.country)
    respond_to do |format|
      UserMailer.with(ebook: @ebook).sale_commission.deliver_later
      UserMailer.with(ebook: @ebook).ebook_statistics.deliver_later
      format.html { redirect_to ebooks_path, notice: "Ebook was successfully purchased." }
    end
  end

  private

  def set_ebook
    @ebook = Ebook.find(params[:id])
  end

  def ebook_params
    params.require(:ebook).permit(:title, :description, :author_id, :ebook_status_id, :preview, :seller_id, :price, :cover)
  end

  def get_query_and_filters
    filters = {}
    filters[:tag] = params["tag"] if params["tag"].present?
    filters[:seller_id] = params["seller"] if params["seller"].present?
    filters[:author_id] = params["author"] if params["author"].present?

    query = ""
    query = params["query"] if params["query"].present?

    [ query, filters ]
  end
end
