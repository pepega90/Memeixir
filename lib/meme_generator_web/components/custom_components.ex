defmodule MemeGeneratorWeb.CustomComponents do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  attr :top_key_event, :string, default: ""
  attr :bot_key_event, :string, default: ""
  attr :get_meme_event, :string, default: ""
  def meme_caption(assigns) do
    ~H"""
      <div class="row p-3">
            <div>

              <div>
                <label for="top_text" class="form-label">Top Text</label>
                <input name="top_text" phx-keyup={@top_key_event} class="form-control" name="top_text" />
              </div>
              <div>
                <label for="bot_text" class="form-label">Bottom Text</label>
                <input class="form-control" name={@bot_key_event} phx-keyup="bot_change" />
              </div>

            </div>

            <div>
              <button phx-click={@get_meme_event} class="btn btn-outline-secondary">Generate Meme</button>
            </div>

      </div>
    """
  end

  attr :current_meme, :string, default: ""
  attr :top_text, :string, default: ""
  attr :bottom_text, :string, default: ""
  def meme_image(assigns) do
    ~H"""
        <div class="meme-generator-container" style="position: relative;">
              <%!-- TOP TEXT --%>
              <div id="top-text-container" style="position: absolute; top: 0; left: 0;">
                <h1 class="text-center" style="margin: 0; padding: 10px; font-size: 2em; color: white; text-shadow: 2px 2px 4px #000;"><%= @top_text %></h1>
              </div>
            <%!-- END TOP TEXT --%>

          <img src={@current_meme} width="500" height="500" />

            <%!-- BOTTOM TEXT --%>
            <div id="bottom-text-container" style="position: absolute; bottom: 0; left: 0;">
              <h1 class="text-center" style="margin: 0; padding: 10px; font-size: 2em; color: white; text-shadow: 2px 2px 4px #000;"><%= @bottom_text %></h1>
            </div>
            <%!-- END BOTTOM TEXT --%>
          </div>
    """
  end

end
