# == Schema Information
#
# Table name: datapool_image_meta
#
#  id                :integer          not null, primary key
#  type              :string(255)
#  title             :string(255)      not null
#  original_filename :string(255)
#  src               :string(255)
#  from_url          :string(255)
#
# Indexes
#
#  index_datapool_image_meta_on_from_url_and_src  (from_url,src) UNIQUE
#  index_datapool_image_meta_on_title             (title)
#

class Datapool::ImageMetum < ApplicationRecord
  IMAGE_FILE_EXTENSIONS = [
    ".agp",
    ".ai", #Illustrator
    ".cdr",
    ".cpc", ".cpi",
    ".eps",
    ".eri",
    ".gif", #GIF
    ".iff", ".ilbm", ".lbm",
    ".ima",
    ".jpg", ".jpeg", #JPEG
    ".jxr", ".hdp", ".wdp",
    ".jp2", ".j2c",
    ".mki",
    ".mag",
    ".pi",
    ".pict", ".pic", ".pct",
    ".pdf", #PDF
    ".png", #PNG
    ".psd", ".psb", ".pdd", #PSD
    ".psp",
    ".svg", #SVG
    ".tga", ".tpic", #TGA 3Dモデルのテクスチャーとかによく使われる
    ".tif", #tif 文字とかフォントとか
    ".webp",
    ".bmp", #BMP
  ]

  CRAWL_IMAGE_ROOT_PATH = "project/crawler/images/"

  def self.match_image_filename(filepath)
    paths = filepath.split("/")
    imagefile_name = paths.detect{|p| IMAGE_FILE_EXTENSIONS.any?{|ie| p.include?(ie)} }
    return "" if imagefile_name.blank?
    ext = IMAGE_FILE_EXTENSIONS.detect{|ie| imagefile_name.include?(ie) }
    return imagefile_name.match(/(.+?#{ext})/).to_s
  end

  def self.s3_file_image_root
    return CRAWL_IMAGE_ROOT_PATH
  end

  def save_filename
    if self.original_filename.present?
      return self.original_filename
    end
    return SecureRandom.hex
  end

  def self.crawl_images!(url:, start_page: 1, end_page: 1, filter: nil, request_method: :get)
    images = []
    (start_page.to_i..end_page.to_i).each do |page|
      address_url = Addressable::URI.parse(url % page.to_s)
      doc = ApplicationRecord.request_and_parse_html(address_url.to_s, request_method)
      images += self.generate_objects_from_parsed_html(doc: doc, filter: filter, from_site_url: address_url.to_s)
    end
    self.import!(images, on_duplicate_key_update: [:title])
    return images
  end

  def self.generate_objects_from_parsed_html(doc:, filter: nil, from_site_url: nil)
    images = []
    if filter.present?
      doc = doc.css(filter)
    end
    doc.css("img").each do |d|
      title = d[:alt]
      if title.blank?
        title = d[:title]
      end
      if title.blank?
        title = d[:name]
      end
      if title.blank?
        title = d.text
      end
      image_url = Addressable::URI.parse(d[:src])
      # base64encodeされたものはschemeがdataになる
      if image_url.scheme != "data"
        image_url = ApplicationRecord.merge_full_url(src: image_url, org: from_site_url)
      end
      # 画像じゃないものも含まれていることもあるので分別する
      fi = FastImage.new(image_url.to_s)
      next if fi.type.blank?
      image = self.new(title: title.to_s, from_url: from_site_url)
      if image_url.scheme == "data"
        image_binary =  Base64.decode64(image_url.to_s.gsub(/data:image\/.+;base64\,/, ""))
        new_filename = SecureRandom.hex + ".#{fi.type.to_s}"
        uploaded_path = self.upload_s3(image_binary, new_filename)
        image.src = "https://taptappun.s3.amazonaws.com/" + uploaded_path
      else
        image.src = image_url.to_s
      end
      image.original_filename = self.match_image_filename(image.src.to_s)
      images << image
    end
    return images
  end

  def download_image_response
    aurl = Addressable::URI.parse(URI.unescape(self.src))
    client = HTTPClient.new
    response = client.get(aurl.to_s)
    return response
  end

  def self.upload_s3(binary, filename)
    s3 = Aws::S3::Client.new
    filepath = self.s3_file_image_root + filename
    s3.put_object(bucket: "taptappun",body: binary, key: filepath, acl: "public-read")
    return filepath
  end

  def convert_to_base64
    filepath = self.src
    ext = File.extname(filepath)
    s3 = Aws::S3::Client.new
    binary = s3.get_object(bucket: "taptappun",key: filepath)
    base64_image = Base64.strict_encode64(binary.body.read)
    return "data:image/" + ext[1..ext.size] + ";base64," + base64_image
  end
end
