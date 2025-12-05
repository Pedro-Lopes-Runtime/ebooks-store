class EbooksController < ApplicationController
  before_action :set_ebook, only: [ :show, :edit, :update, :destroy ]

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
      render "new"
    end
  end

  def edit
  end

  def update
    if @ebook.update(ebook_params)
      redirect_to @ebook
    else
      render "edit"
    end
  end

  def destroy
    @ebook.destroy
  end

  private

  def set_ebook
    @ebook = Ebook.find(params[:id])
  end

  def ebook_params
    params.require(:ebook).permit(:title, :description, :author_id)
  end
end
