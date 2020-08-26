class LearningResourceSerializer < ActiveModel::Serializer
  attributes :id, :title, :is_published, :url

  def url
    admin_learning_resource_url(object)
  end

end