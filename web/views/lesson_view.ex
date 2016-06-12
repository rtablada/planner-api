defmodule Planner.LessonView do
  use Planner.Web, :view

  def render("index.json", %{lessons: lessons}) do
    %{data: render_many(lessons, Planner.LessonView, "lesson.json")}
  end

  def render("show.json", %{lesson: lesson}) do
    %{data: render_one(lesson, Planner.LessonView, "lesson.json")}
  end

  def render("lesson.json", %{lesson: lesson}) do
    %{id: lesson.id,
      week: lesson.week,
      day: lesson.day,
      date: lesson.date,
      image: lesson.image,
      quote: lesson.quote,
      instructor_id: lesson.instructor_id}
  end
end
