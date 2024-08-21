class ArticleVersion < ApplicationRecord
  belongs_to :original, class_name: "Article"
  belongs_to :unbiased, class_name: "Article", optional: true
  
  after_destroy :destroy_associated

  def destroy_associated
    original.destroy
    unbiased.destroy
  end
end
