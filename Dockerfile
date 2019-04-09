FROM crystallang/crystal:0.27.2

WORKDIR /app

COPY shard.* /app/
RUN shards install

COPY . /app

CMD ["bash"]
