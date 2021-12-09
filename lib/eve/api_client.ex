defmodule Eve.APIClient do
	alias HTTPoison, as: HTTP
	alias Jason

	@orders_url "https://esi.evetech.net/latest/markets/10000002/types/?"
	@lookup_url "https://esi.evetech.net/latest/universe/names/?"

	@default_query %{ "datasource" => "tranquility" }

	def get_order_types(page \\ 1) do
		initial_response = fetch_order_types!(page)
		max_pages = get_max_pages(initial_response)
		page_range = (page + 1)..max_pages

		stream = Task.async_stream(page_range, &fetch_order_types!(&1))
		Enum.reduce(stream, [], fn {:ok, response}, type_ids ->
			type_ids ++ Jason.decode!(response.body)
		end)
	end

	def get_universe_names(type_ids) do
		chunked_type_ids = type_ids
			|> Enum.sort()
			|> Enum.dedup()
			|> Enum.chunk_every(1000)
		
		stream = Task.async_stream(chunked_type_ids, &fetch_universe_names!(&1))

		Enum.reduce(stream, [], fn {:ok, response}, names ->
			names ++ Jason.decode!(response.body)
		end)
	end
	
	defp fetch_order_types!(page) do
		query = Map.put(@default_query, "page", page)
		url = @orders_url <> URI.encode_query(query)
		{:ok, %HTTP.Response{ status_code: 200} = response} = HTTP.get(url)

		response
	end

	defp fetch_universe_names!(type_ids) do
		url = @lookup_url <> URI.encode_query(@default_query)
		{:ok, %HTTP.Response{ status_code: 200} = response} = HTTP.post(url, Jason.encode!(type_ids))

		response
	end

	defp get_max_pages(response) do
		Enum.find(response.headers, &(elem(&1, 0) == "X-Pages"))
		|> elem(1)
		|> Integer.parse()
		|> elem(0)
	end
end