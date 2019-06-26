defmodule Acqdat.Mailer.NotificationEmailTest do
  use ExUnit.Case
  use Acqdat.DataCase
  use Bamboo.Test

  import Acqdat.Support.Factory
  alias Acqdat.Mailer.NotificationEmail
  alias Acqdat.Mailer

  test "send email" do
    device = insert(:device)
    message_list = [%{"Temperature" => %{"humid" => 35}}, %{"Temperature" => %{"temp" => 90}}]

    email = NotificationEmail.email(device, message_list)
    email |> Mailer.deliver_now()
    assert_delivered_email(email)
  end
end
