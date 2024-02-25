defmodule MemeGeneratorWeb.MemeGeneratorLive.Index do
  use MemeGeneratorWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
      <h1 id="title-meme" class="display-5 text-center py-4">Meme Generator</h1>

      <div class="card">
          <div class="card-body flex">
            <div class="meme-generator-container" style="position: relative;">
              <%!-- TOP TEXT --%>
              <div id="top-text-container" style="position: absolute; top: 0; left: 0;">
                <h1 class="text-center" style="margin: 0; padding: 10px; font-size: 2em; color: white; text-shadow: 2px 2px 4px #000;"><%= @top_text %></h1>
              </div>
            <%!-- END TOP TEXT --%>

          <img src={@current_meme["url"]} width="500" height="500" />

            <%!-- BOTTOM TEXT --%>
            <div id="bottom-text-container" style="position: absolute; bottom: 0; left: 0;">
              <h1 class="text-center" style="margin: 0; padding: 10px; font-size: 2em; color: white; text-shadow: 2px 2px 4px #000;"><%= @bottom_text %></h1>
            </div>
            <%!-- END BOTTOM TEXT --%>
          </div>

          <div class="row p-3">
            <div>
              <div>
                <label for="top_text" class="form-label">Top Text</label>
                <input name="top_text" phx-keyup="top_change" class="form-control" name="top_text" />
              </div>
              <div>
                <label for="bot_text" class="form-label">Bottom Text</label>
                <input class="form-control" name="bot_text" phx-keyup="bot_change" />
              </div>
            </div>

            <div>
              <button phx-click="get_meme" class="btn btn-outline-secondary">Generate Meme</button>
            </div>
            </div>
          </div>
      </div>
      <script>
       window.addEventListener("DOMContentLoaded", () => {
        let isFollowing = false;
        let currentFollower; // This will reference the current text element being dragged
        const topFollower = document.getElementById('top-text-container'); // Assuming this is the id of the top text container
        const bottomFollower = document.getElementById('bottom-text-container'); // Assuming this is the id of the bottom text container
        const imageContainer = document.querySelector('.meme-generator-container'); // This should be the container of the image and text

        function mouseDownHandler(e, follower) {
          if (e.button === 0 && isCursorOverDiv(e.clientX, e.clientY, follower)) {
            isFollowing = true;
            currentFollower = follower; // Set the currentFollower to the one being interacted with
            const offsetX = e.clientX - follower.getBoundingClientRect().left;
            const offsetY = e.clientY - follower.getBoundingClientRect().top;
            follower.dataset.offsetX = offsetX;
            follower.dataset.offsetY = offsetY;
          }
        }

        document.addEventListener('mousedown', function(e) {
          mouseDownHandler(e, topFollower);
          mouseDownHandler(e, bottomFollower);
        });

        document.addEventListener('mouseup', function() {
          isFollowing = false;
          currentFollower = null; // Clear the currentFollower when the mouse is released
        });

        document.addEventListener('mousemove', function(e) {
          if (isFollowing && currentFollower) {
            const mouseX = e.clientX - imageContainer.getBoundingClientRect().left;
            const mouseY = e.clientY - imageContainer.getBoundingClientRect().top;

            // Calculate the new position
            const newLeft = mouseX - currentFollower.dataset.offsetX;
            let newTop = mouseY - currentFollower.dataset.offsetY;

            // Get the boundaries
            const leftBoundary = 0;
            const topBoundary = 0;
            const rightBoundary = imageContainer.offsetWidth - currentFollower.offsetWidth;
            let bottomBoundary = imageContainer.offsetHeight - currentFollower.offsetHeight;

            // Special handling for the bottom text to ensure it can move to the bottom edge of the image container
            if (currentFollower === bottomFollower) {
              bottomBoundary += bottomFollower.offsetHeight; // Allow the bottom text to move further down
              newTop = Math.min(newTop, bottomBoundary); // Adjust newTop if it's beyond the bottom boundary
            }

            // Constrain the position within the boundaries
            currentFollower.style.left = Math.max(leftBoundary, Math.min(newLeft, rightBoundary)) + 'px';
            currentFollower.style.top = Math.max(topBoundary, newTop) + 'px';
          }
        });


        function isCursorOverDiv(mouseX, mouseY, div) {
          const rect = div.getBoundingClientRect();
          return mouseX >= rect.left && mouseX <= rect.right &&
                mouseY >= rect.top && mouseY <= rect.bottom;
        }
      });
      </script>
    """
  end

  @url "https://api.imgflip.com/get_memes"

  @impl true
  def mount(_session, _params, socket) do
    case HTTPoison.get(@url) do
      {:ok, %{status_code: 200, body: body}} ->
        res = Poison.decode!(body)
        %{"data" => %{"memes" => data}} = res
        {:ok, socket |> assign(
          data: data,
          current_meme: data |> Enum.random,
          top_text: "",
          bottom_text: ""
        )}

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts "++++++ ERROR ++++++"
        IO.inspect reason
        {:ok, socket}
    end
  end

  @impl true
  def handle_event("bot_change", %{"value" => val} = _params, socket), do: {:noreply, socket |> assign(bottom_text: val)}

  def handle_event("top_change", %{"value" => val} = _params, socket), do: {:noreply, socket |> assign(top_text: val)}

  def handle_event("get_meme", _params, %{assigns: %{data: data}} = socket), do: {:noreply, socket |> assign(current_meme: data |> Enum.random, top_text: "", bottom_text: "")}

end
