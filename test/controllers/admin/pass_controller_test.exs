defmodule Student.Admin.PassControllerTest do
  use Student.ConnCase

  alias Student.Pass
  @valid_attrs %{price: "120.5", type: "bike"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, admin_pass_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing passes"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, admin_pass_path(conn, :new)
    assert html_response(conn, 200) =~ "New pass"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, admin_pass_path(conn, :create), pass: @valid_attrs
    assert redirected_to(conn) == admin_pass_path(conn, :index)
    assert Repo.get_by(Pass, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, admin_pass_path(conn, :create), pass: @invalid_attrs
    assert html_response(conn, 200) =~ "New pass"
  end

  test "shows chosen resource", %{conn: conn} do
    pass = Repo.insert! %Pass{}
    conn = get conn, admin_pass_path(conn, :show, pass)
    assert html_response(conn, 200) =~ "Show pass"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, admin_pass_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    pass = Repo.insert! %Pass{}
    conn = get conn, admin_pass_path(conn, :edit, pass)
    assert html_response(conn, 200) =~ "Edit pass"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    pass = Repo.insert! %Pass{}
    conn = put conn, admin_pass_path(conn, :update, pass), pass: @valid_attrs
    assert redirected_to(conn) == admin_pass_path(conn, :show, pass)
    assert Repo.get_by(Pass, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    pass = Repo.insert! %Pass{}
    conn = put conn, admin_pass_path(conn, :update, pass), pass: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit pass"
  end

  test "deletes chosen resource", %{conn: conn} do
    pass = Repo.insert! %Pass{}
    conn = delete conn, admin_pass_path(conn, :delete, pass)
    assert redirected_to(conn) == admin_pass_path(conn, :index)
    refute Repo.get(Pass, pass.id)
  end
end
