defmodule Acqdat.Model.User do
  @moduledoc """
  Exposes APIs for handling user related fields.
  """

  alias Acqdat.Schema.User
  alias Acqdat.Repo

  @doc """
  Creates a User with the supplied params.

  Expects following keys.
  - `first_name`
  - `last_name`
  - `email`
  - `password`
  - `password_confirmation`
  """
  @spec create(map) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    changeset = User.changeset(%User{}, params)
    Repo.insert(changeset)
  end

  @doc """
  Returns a user by the supplied email.
  """
  def get(id) when is_integer(id) do
    Repo.get_by(User, id: id)
  end

  @doc """
  Returns a user by the supplied email.
  """
  def get(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Deletes a User.

  Expects `user_id` as the argument.
  """
  @spec delete(non_neg_integer) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def delete(user_id) do
    user_id |> Repo.get!(User) |> Repo.delete()
  end
end
