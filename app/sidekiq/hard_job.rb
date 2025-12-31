class HardJob
  include Sidekiq::Job

  def perform(ebook_id)
    UserMailer.with(ebook_id: ebook_id).sale_commission.deliver_now
    UserMailer.with(ebook_id: ebook_id).ebook_statistics.deliver_now
  end
end
