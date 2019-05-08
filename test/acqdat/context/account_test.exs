defmodule Acqdat.Context.AccountTest do

  use ExUnit.Case, async: true
  use Acqdat.DataCase

  import Acqdat.Support.Factory
  alias Acqdat.Context.Account

  describe "register" do
    test "registers a user successfully" do
      params = %{
        first_name: "Tony",
        last_name: "Stark",
        email: "tony@starkindustries.com",
        password: "marvel_connect",
        password_confirmation: "marvel_connect"
      }

      assert {:ok, user} = Account.register(params)
      assert user.id
      assert user.first_name == params.first_name
    end

    test "fails if params empty" do
      params = %{}
      assert {:error, changeset} = Account.register(params)
      assert %{
        email: ["can't be blank"],
        first_name: ["can't be blank"],
        password: ["can't be blank"],
        password_confirmation: ["can't be blank"]
      } == errors_on(changeset)
    end
  end

  describe "authenticate/2" do
    setup do
      password = "marvel_connect"
      user = build(:user) |> set_password(password) |> insert()
      [user: user, password: password]
    end

    test "authenticates a registered user", context do
      %{user: user, password: password} = context

      assert {:ok, %Acqdat.Schema.User{}} = Account.authenticate(user.email, password)
    end

    test "returns error if email not registered", context do
      %{user: user, password: password} = context
      email = "abc@gmail.com"

      assert email != user.email
      assert {:error, message} = Account.authenticate(email, password)
      assert message == :not_found
    end

    test "returns error if password wrong", context do
      %{user: user} = context
      password = "abcd1234"

      assert {:error, message} = Account.authenticate(user.email, password)
      assert message == :not_found
    end
  end

end
