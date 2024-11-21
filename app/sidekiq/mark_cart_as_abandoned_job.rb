class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform
    mark_abandoned_carts
    remove_old_abandoned_carts
  end

  private

  def mark_abandoned_carts
    Cart.where(abandoned_at: nil)
       .where('last_interaction_at < ?', 3.hours.ago)
       .update_all(abandoned_at: Time.current)
  end

  def remove_old_abandoned_carts
    Cart.where('abandoned_at < ?', 7.days.ago).destroy_all
  end
end
