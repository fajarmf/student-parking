defmodule Student.PageControllerTest do
  use Student.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Student App!"
  end
end
