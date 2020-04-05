.DELETE_ON_ERROR:

all: setup_git_hooks

.PHONY: all

setup_git_hooks:
	ln -sf ../../git_hooks/pre_commit.exs .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit
