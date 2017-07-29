FROM vborja/asdf-alpine:elixir-1.5.0-opt-20

ADD . /asdf/bard
WORKDIR /asdf/bard
USER asdf

EXPOSE 80
ENV PORT 80

RUN mix hex.local -f

CMD ["npm", "start"]
