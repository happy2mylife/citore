class CreateCrawlTargetUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :crawl_target_urls do |t|
      t.string :source_type, null: false
      t.string :crawl_from_keyword
      t.string :protocol, null: false
      t.string :host, null: false
      t.integer :port
      t.string :path, null: false, default: ''
      t.text :query, null: false
      t.datetime :crawled_at
      t.string :content_type
      t.integer :status_code
      t.string :message
      t.timestamps
    end

    add_index :crawl_target_urls, :crawl_from_keyword
    add_index :crawl_target_urls, [:host, :path]
    add_index :crawl_target_urls, [:crawled_at, :status_code]
  end
end
