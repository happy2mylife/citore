# == Schema Information
#
# Table name: image_meta
#
#  id                :integer          not null, primary key
#  type              :string(255)
#  title             :string(255)      not null
#  original_filename :string(255)
#  filename          :string(255)
#  src               :string(255)
#  from_site_url     :string(255)
#  checksum          :string(255)
#
# Indexes
#
#  index_image_meta_on_checksum                        (checksum)
#  index_image_meta_on_from_site_url_and_src           (from_site_url,src) UNIQUE
#  index_image_meta_on_original_filename_and_filename  (original_filename,filename) UNIQUE
#  index_image_meta_on_title                           (title)
#

class CharacterSerifImage < ImageMetum
  IMAGE_S3_FILE_ROOT = "project/characterserif/images/"

  def s3_file_image_root
    return CharacterSerifImage::IMAGE_S3_FILE_ROOT
  end
end
