defmodule MemeGenerator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MemeGeneratorWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MemeGenerator.PubSub},
      # Start Finch
      {Finch, name: MemeGenerator.Finch},
      # Start the Endpoint (http/https)
      MemeGeneratorWeb.Endpoint
      # Start a worker by calling: MemeGenerator.Worker.start_link(arg)
      # {MemeGenerator.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MemeGenerator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MemeGeneratorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
