defmodule SaffronWeb.GameLive do
  use Phoenix.LiveView

  alias SaffronWeb.GameView

  def render(assigns) do
    Phoenix.View.render(GameView, "game.html", assigns)
  end

  def mount(_session, socket) do
    if connected?(socket), do: :timer.send_interval(13, self(), :tick)

    {:ok,
     assign(socket,
       left_pressed: false,
       right_pressed: false,
       up_pressed: false,
       down_pressed: false,
       camera: %{
         # x, y, z
         position: {1.0, 0.0, 1.0},
         # y, in rads
         angle: 0.0
       }
     )}
  end

  def handle_event("keydown", "ArrowUp", socket) do
    {:noreply, assign(socket, up_pressed: true)}
  end

  def handle_event("keydown", "ArrowDown", socket) do
    {:noreply, assign(socket, down_pressed: true)}
  end

  def handle_event("keydown", "ArrowLeft", socket) do
    {:noreply, assign(socket, left_pressed: true)}
  end

  def handle_event("keydown", "ArrowRight", socket) do
    {:noreply, assign(socket, right_pressed: true)}
  end

  def handle_event("keyup", "ArrowUp", socket) do
    {:noreply, assign(socket, up_pressed: false)}
  end

  def handle_event("keyup", "ArrowDown", socket) do
    {:noreply, assign(socket, down_pressed: false)}
  end

  def handle_event("keyup", "ArrowLeft", socket) do
    {:noreply, assign(socket, left_pressed: false)}
  end

  def handle_event("keyup", "ArrowRight", socket) do
    {:noreply, assign(socket, right_pressed: false)}
  end

  def handle_event("keydown", key, socket) do
    {:noreply, socket}
  end

  def get_camera_position(socket), do: socket.assigns.camera.position
  def get_camera_angle(socket), do: socket.assigns.camera.angle

  def set_camera_position(socket, position),
    do: update(socket, :camera, &Map.put(&1, :position, position))

  def set_camera_angle(socket, angle), do: update(socket, :camera, &Map.put(&1, :angle, angle))

  def convert_angle_to_vec(angle), do: {:math.cos(angle), :math.sin(angle)}

  def handle_event("keyup", _, socket), do: {:noreply, socket}

  def turn_left(socket) do
    angle = get_camera_angle(socket)
    set_camera_angle(socket, angle - 0.01)
  end

  def turn_right(socket) do
    angle = get_camera_angle(socket)
    set_camera_angle(socket, angle + 0.01)
  end

  def move_forward(socket) do
    angle = get_camera_angle(socket)
    {x, y, z} = get_camera_position(socket)

    {x, z} =
      {x * :math.cos(angle) - z * :math.sin(angle), z * :math.cos(angle) + x * :math.sin(angle)}

    set_camera_position(socket, {x, y, z})
  end

  def move_backward(socket) do
    {x, y, z} = get_camera_position(socket)

    set_camera_position(socket, {x - 1, y, z})
  end

  def handle_info(:tick, socket) do
    socket =
      cond do
        socket.assigns.up_pressed -> move_forward(socket)
        socket.assigns.down_pressed -> move_backward(socket)
        true -> socket
      end

    socket =
      cond do
        socket.assigns.left_pressed -> turn_left(socket)
        socket.assigns.right_pressed -> turn_right(socket)
        true -> socket
      end

    {:noreply, socket}
  end
end
