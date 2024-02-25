defmodule MemeGeneratorWeb.Router do
  use MemeGeneratorWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MemeGeneratorWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MemeGeneratorWeb do
    pipe_through :browser

    # get "/", PageController, :home
    live "/", MemeGeneratorLive.Index, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", MemeGeneratorWeb do
  #   pipe_through :api
  # end

  # Enable Swoosh mailbox preview in development
  # if Application.compile_env(:meme_generator, :dev_routes) do

  #   scope "/dev" do
  #     pipe_through :browser

  #     forward "/mailbox", Plug.Swoosh.MailboxPreview
  #   end
  # end
end
