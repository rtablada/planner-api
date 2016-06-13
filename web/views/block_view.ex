defmodule Planner.BlockView do
  use Planner.Web, :view
  use JaSerializer.PhoenixView

  attributes [:title, :estimated_time, :completed, :time_elapsed]
  has_one :lesson, link: :lesson_link

  def lesson_link(block, conn) do
    user_url(conn, :show, block.lesson_id)
  end
end
