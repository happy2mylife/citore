class AddColumnToFeyKunAiInquiryTweetImages < ActiveRecord::Migration[5.1]
  def change
    add_column :fey_kun_ai_inquiry_tweet_images, :state, :integer, null: false, default: 0
  end
end
