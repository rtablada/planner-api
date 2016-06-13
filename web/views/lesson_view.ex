defmodule Planner.LessonView do
  use Planner.Web, :view
  use JaSerializer.PhoenixView

  attributes [:week, :day, :date, :image, :quote]
end
