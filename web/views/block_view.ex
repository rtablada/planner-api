defmodule Planner.BlockView do
  use Planner.Web, :view
  use JaSerializer.PhoenixView

  attributes [:title, :estimated_time, :completed, :time_elapsed, :order]
  has_one :lesson, serializer: Planner.LessonView

  def lesson_link(block, conn) do
    lesson_url(conn, :show, block.lesson_id)
  end
end
