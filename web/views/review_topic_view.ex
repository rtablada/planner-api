defmodule Planner.ReviewTopicView do
  use Planner.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :done, :inserted_at, :updated_at]
  
  has_one :lesson,
    field: :lesson_id,
    type: "lesson"

end
