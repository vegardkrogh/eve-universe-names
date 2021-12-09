defmodule Eve do
  alias Eve.APIClient

  def print_universe_names() do
		type_ids = APIClient.get_order_types()
		names = APIClient.get_universe_names(type_ids)

		names = names
		|> Enum.map(&(&1["name"]))
		|> Enum.sort()
		|> Enum.join("\n")
    

    if Mix.env() != :test do
      IO.puts(names)
    else
      names
    end
	end
end
