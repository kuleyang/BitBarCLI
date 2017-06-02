run:
	ls Sources/*.swift | entr bash -c 'swift build && ./.build/debug/BitBarCli plugins-refresh hello.10m.sh'
#  2>&1 | xcpretty