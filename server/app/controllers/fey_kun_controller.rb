class FeyKunController < BaseController
  protect_from_forgery

  def report
  end

  def analized
    logger.info params
    image = FeyKunAi::InquiryTweetImage.find_by(id: params[:image_id])
    image.output ||= {}

    object_image_name = FeyKunAi::InquiryTweetImage.upload_s3(params[:object_img])
    err_image_name = FeyKunAi::InquiryTweetImage.upload_s3(params[:error_img])

    image.output = image.output.merge(JSON.parse(params[:result]).merge(object_image_name: object_image_name, err_image_name: err_image_name))
    image.save!

    head(:ok)
  end
end