class CreateImageMeta < ActiveRecord::Migration[5.0]
  def change
    create_table :image_meta do |t|
      t.string :type
      t.string :title, null: false
      t.string :original_filename
      t.string :filename
      t.string :src
      t.string :from_site_url
      t.string :checksum
    end
    add_index :image_meta, :title
    add_index :image_meta, [:from_site_url, :src], unique: true
    add_index :image_meta, [:original_filename, :filename], unique: true
    add_index :image_meta, :checksum
  end
end