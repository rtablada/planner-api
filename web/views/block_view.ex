defmodule Planner.BlockView do
  use Planner.Web, :view

  def render("index.json", %{blocks: blocks}) do
    %{data: render_many(blocks, Planner.BlockView, "block.json")}
  end

  def render("show.json", %{block: block}) do
    %{data: render_one(block, Planner.BlockView, "block.json")}
  end

  def render("block.json", %{block: block}) do
    %{id: block.id,
      title: block.title,
      estimated_time: block.estimated_time,
      completed: block.completed,
      time_elapsed: block.time_elapsed,
      lesson_id: block.lesson_id}
  end
end
