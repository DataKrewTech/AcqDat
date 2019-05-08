defmodule Acqdat.Support.Factory do
  use ExMachina.Ecto, repo: Acqdat.Repo

  alias Acqdat.Schema.{User}

  def user_factory() do
    %User{
      first_name: "Tony",
      last_name: "Stark",
      email: "tony@starkindustries.com",
      password_hash: ""
    }
  end

  def set_password(user, password) do
    user
    |> User.changeset(%{password: password, password_confirmation: password})
    |> Ecto.Changeset.apply_changes()
  end
end
