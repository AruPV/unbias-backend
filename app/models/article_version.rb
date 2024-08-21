class ArticleVersion < ApplicationRecord
  belongs_to :original, class_name: "Article"
  belongs_to :unbiased, class_name: "Article", optional: true
end
