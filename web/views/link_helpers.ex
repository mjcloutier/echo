defmodule Echo.LinkHelpers do
  use Phoenix.HTML

  def active_class(conn, link_path) do
    current_path = Path.join(["/" | conn.path_info])

    case active_path?(current_path, link_path) do
      true -> "active"
      false -> nil
    end
  end

  defp active_path?("/", "/"), do: true
  defp active_path?(_current_path, "/"), do: false
  defp active_path?(current_path, link_path) do
    String.starts_with?(current_path, link_path)
  end
end
