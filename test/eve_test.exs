defmodule EveTest do
  use ExUnit.Case

  alias Eve.APIClient

  test "gets names" do
    assert type_ids = APIClient.get_order_types()
    assert length(type_ids) > 1000
    
    assert universe_names = APIClient.get_universe_names(type_ids)
    assert length(type_ids) > 1000
  end

  test "print names" do
    assert Eve.print_universe_names()
  end
end