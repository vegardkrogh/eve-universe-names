FROM bitwalker/alpine-elixir:latest as build

COPY . .

ENV MIX_ENV=prod
RUN mix deps.get

FROM build

ENTRYPOINT ["mix", "run", "-e", "Eve.print_universe_names()"]