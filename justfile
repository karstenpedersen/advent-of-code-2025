# show recipes
default:
    @just --list

# setup new project
setup folder link:
    @gleam new {{folder}}
    @rm -r {{folder}}/.github
    @mkdir {{folder}}/inputs
    @echo -e "# {{folder}}\n\n{{link}}" > {{folder}}/README.md