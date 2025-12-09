class EbooksController < ApplicationController
  before_action :set_ebook, only: [ :show, :edit, :update, :destroy, :update_status ]

  def index
    @ebooks = Ebook.all
  end

  def show
  end

  def new
    @ebook = Ebook.new
  end

  def create
    @ebook = Ebook.new(ebook_params)
    if @ebook.save
      redirect_to @ebook
    else
      render "new", status: 422
    end
  end

  def edit
  end

  def update
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

  private

  def set_ebook
    @ebook = Ebook.find(params[:id])
  end

  def ebook_params
    params.require(:ebook).permit(:title, :description, :author_id, :ebook_status_id)
  end
end
