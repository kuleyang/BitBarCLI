run:
	ls Sources/*.swift | entr bash -c 'swift build && ./.build/debug/BitBarCli plugins:list'
install:
	swift build -c release
	ln -srf ./.build/release/BitBarCli /usr/local/bin/bitbar
