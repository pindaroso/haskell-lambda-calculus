all:
	@stack build
	@stack exec lambda-calculus-exe

docker:
	@docker build .
