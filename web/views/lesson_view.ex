defmodule Planner.LessonView do
  use Planner.Web, :view
  use JaSerializer.PhoenixView

  attributes [:week, :day, :date, :image, :quote]
  has_many(:block, serializer: Planner.BlockView)
end
