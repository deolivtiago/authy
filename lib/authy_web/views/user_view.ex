defmodule AuthyWeb.UserView do
  use AuthyWeb, :view
  alias AuthyWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: %{users: render_many(users, UserView, "user.json")}}
  end

  def render("show.json", %{user: user, token: token}) do
    %{data: %{user: render_one(user, UserView, "user.json"), token: token}}
  end

  def render("show.json", %{user: user}) do
    %{data: %{user: render_one(user, UserView, "user.json")}}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      email: user.email
    }
  end

  def render("signin.json", %{token: token}), do: %{data: %{token: token}}
end
