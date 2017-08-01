FROM vborja/asdf-alpine:elixir-1.5.0-nodejs-8.2.1

COPY . /asdf/bard
WORKDIR /asdf/bard
USER asdf

EXPOSE 80
ENV PORT 80

RUN chown -R asdf /asdf

RUN npm install -g yarn
RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get
RUN cd examples/BardBackend && mix deps.get
RUN cd examples/BardWeb && yarn install
CMD ["npm", "start"]
