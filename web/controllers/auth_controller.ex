defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  plug Ueberauth

  alias Discuss.User
  def callback(%{assigns: %{ueberauth_auth: auth}}=conn, _params) do
  #

    #fetches user params
    user_params = %{provider: "github", token: auth.credentials.token,email: auth.info.email }
    changeset = User.changeset(%User{}, user_params)
    sign_in(conn, changeset)
  end

  def sign_in(conn, changeset) do
    case insert_or_update(changeset) do
      {:ok, user} ->

      # what is happening here to the input type??
      # what are the argument type for redirect?
      # in put_session, the arguent a tuple? or merely takes
      # an atom as first argument and string as second?
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id )
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: topic_path(conn, :index))

    end
  end

  defp insert_or_update(changeset) do
    case Repo.get_by(User,email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end
