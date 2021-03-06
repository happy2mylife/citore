# == Schema Information
#
# Table name: twitter_bots
#
#  id                   :integer          not null, primary key
#  type                 :string(255)      not null
#  action               :integer          not null
#  action_value         :string(255)      not null
#  action_resource_path :string(255)
#  action_id            :string(255)      not null
#  action_time          :datetime         not null
#  action_from_id       :integer
#
# Indexes
#
#  index_twitter_bots_on_action_from_id   (action_from_id)
#  index_twitter_bots_on_action_id        (action_id)
#  index_twitter_bots_on_type_and_action  (type,action)
#

class TwitterBot < TwitterRecord
  belongs_to :approached, class_name: 'TwitterBotApproach', foreign_key: :action_from_id
  enum action: [:tweet, :follow, :reply, :retweet, :resource_post]

  def self.tweet_routines!
    #[Mone::TwitterBot, Shiritori::TwitterBot, Sugarcoat::TwitterBot, Citore::TwitterBot].each do |clazz|
    [Mone::TwitterBot].each do |clazz|
      bot = clazz.new(action: :tweet)
      bot.tweet!(clazz.get_tweet)
    end
  end

  def self.bots_activate
    #[Mone::TwitterBot, Shiritori::TwitterBot, Sugarcoat::TwitterBot, Citore::TwitterBot].each do |clazz|
    [Mone::TwitterBot].each do |clazz|
      stream = clazz.get_twitter_stream_client
      #フォローされたらフォロー返し
      stream.on_event(:favorite) do |event|
        p event[:source]
        bot = clazz.new(action: :follow)
        bot.follow!(twitter_user_id: event[:source][:id], twitter_screen_name: event[:source][:screen_name])
      end
      client.on_event(:follow) do |event|
        p event[:source]
        bot = clazz.new(action: :follow)
        bot.follow!(twitter_user_id: event[:source][:id], twitter_screen_name: event[:source][:screen_name])
      end
    end
  end

  def self.get_twitter_stream_client(twitter_client_id)
    key = "twitter_" + twitter_client_id
    apiconfig = YAML.load(File.open(Rails.root.to_s + "/config/apiconfig.yml"))
    extra_info = ExtraInfo.read_extra_info
    stream_client = TweetStream::Client.new
    stream_client.consumer_key       = apiconfig["twitter"]["consumer_key"]
    stream_client.consumer_secret    = apiconfig["twitter"]["consumer_secret"]
    stream_client.oauth_token        = extra_info[key]["token"]
    stream_client.oauth_token_secret = extra_info[key]["token_secret"]
    stream_client.auth_method        = :oauth
    return stream_client
  end

  def tweet!(text)
    twitter_client = TwitterRecord.get_twitter_rest_client("citore")
    tweeted = twitter_client.update(text)
    update!(action_id: tweeted.id, action_value: text, action_time: tweeted.created_at)
  end

  def follow!(twitter_user_id:, twitter_screen_name:)
    twitter_client = TwitterRecord.get_twitter_rest_client("citore")
    followed = twitter_client.follow(twitter_screen_name)
    p followed
  end
end
