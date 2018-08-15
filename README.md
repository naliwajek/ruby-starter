Ruby project tempalte from [naliwajek/ruby-starter](https://github.com/naliwajek/ruby-starter)

# Count views

Script counts views from the `./data/webserver.log` file.

Build image

```
make build
```

To see results run:

```
make views
```

It will execute `bundle exec ruby main.rb ./data/webserver.log` in Docker for your convienience.

If you want to run script and provide a path to the file yourself, run `make ash` to get shell access to the Docker.

To run tests with `guard` gem execute:

```
make test
```

All should be green.

Presenters and strategies are tested implicitly through unit tests of Use Cases and acceptance specs.

This setup should allow us to willy-nilly change the sorting order (ascending or descending), counting strategy (all or only unique) and form in which data should be presented e.g JSON or printable list.

## Other commands

To get into `ash` shell run:

```
make ash
```

And then to get into project console

```
bundle console
```
