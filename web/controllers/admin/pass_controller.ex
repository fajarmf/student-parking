defmodule Student.Admin.PassController do
  use Student.Web, :controller

  alias Student.Pass

  def index(conn, _params) do
    passes = Repo.all(Pass)
    render(conn, "index.html", passes: passes)
  end

  def new(conn, _params) do
    changeset = Pass.changeset(%Pass{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"pass" => pass_params}) do
    changeset = Pass.changeset(%Pass{}, pass_params)

    case Repo.insert(changeset) do
      {:ok, _pass} ->
        conn
        |> put_flash(:info, "Pass created successfully.")
        |> redirect(to: admin_pass_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    pass = Repo.get!(Pass, id)
    render(conn, "show.html", pass: pass)
  end

  def edit(conn, %{"id" => id}) do
    pass = Repo.get!(Pass, id)
    changeset = Pass.changeset(pass)
    render(conn, "edit.html", pass: pass, changeset: changeset)
  end

  def update(conn, %{"id" => id, "pass" => pass_params}) do
    pass = Repo.get!(Pass, id)
    changeset = Pass.changeset(pass, pass_params)

    case Repo.update(changeset) do
      {:ok, pass} ->
        conn
        |> put_flash(:info, "Pass updated successfully.")
        |> redirect(to: admin_pass_path(conn, :show, pass))
      {:error, changeset} ->
        render(conn, "edit.html", pass: pass, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    pass = Repo.get!(Pass, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(pass)

    conn
    |> put_flash(:info, "Pass deleted successfully.")
    |> redirect(to: admin_pass_path(conn, :index))
  end
end
