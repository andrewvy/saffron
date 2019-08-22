defmodule SaffronWeb.PageController do
    use SaffronWeb, :controller

    def index(conn, _params) do
        render(conn, "index.html")
    end
end