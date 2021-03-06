class Citore::WordsController < BaseController
  def index
    readings = Citore::EroticWord.reading_words
    render :json => readings
  end

  def search
    natto = ApplicationRecord.get_natto
    sanitaized_word = ApplicationRecord.basic_sanitize(params[:text].to_s)
    reading = ApplicationRecord.reading(sanitaized_word)
    split_words = ApplicationRecord.ngram(reading, 2).uniq
    ngrams = NgramWord.where(from_type: "Citore::EroticWord", bigram: split_words).includes(:from)
    erotic_word = ngrams.map(&:from).uniq.select{|citore_erotic_word| reading.include?(citore_erotic_word.reading) }.sample
    hash = {}
    if erotic_word.present?
      hash = erotic_word.attributes.slice("id", "origin", "reading")
      hash["available_speacker_names"] = erotic_word.voices.pluck(:speaker_name).uniq
    end
    render :json => hash
  end
end
