
# Migrating Node CSV project to the Lerna monorepo

Generates the `./node-csv` directory containing the [Node CSV](https://csv.js.org/) project files reorganized as the Lerna monorepo.

## Dependencies

The project uses [`git-filter-repo`](https://github.com/newren/git-filter-repo/) to rewrite commit histories. To install this package on macOS using [Homebrew](https://brew.sh/), run the command:

```
# For macOS only
brew install git-filter-repo
```

Installation instructions for other OS are available [here](https://github.com/newren/git-filter-repo/blob/main/INSTALL.md).

## Usage

To generate the `./node-csv` directory with all the monorepo files, run the migration bash script using the command:

```
./bin/migrate.sh
```

## Author

Sergei Kudinov   
sergei@adaltas.com   
Developer and Big Data Engineer at [Adaltas](https://www.adaltas.com/)
