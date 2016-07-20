defmodule Planner.LessonView do
  use Planner.Web, :view
  use JaSerializer.PhoenixView

  attributes [:week, :day, :date, :image, :quote]
  has_many(:blocks, serializer: Planner.BlockView)
  has_many(:review_topics, serializer: Planner.ReviewTopicView)
end
