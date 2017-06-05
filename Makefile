CLI=./.build/debug/BitBarCli
PLUGIN=hello.10m.sh
run:
	ls Sources/*.swift | entr bash -c 'swift build && ./.build/debug/BitBarCli plugins:list'
# install:
# 	swift build -c release
# 	ln -srf ./.build/release/BitBarCli /usr/local/bin/bitbar
install:
	swift build
	ln -srf ./.build/debug/BitBarCli /usr/local/bin/bitbar
test:
	swift build
	${CLI} plugin:store:push ${PLUGIN} XYX
	${CLI} plugin:store:ret ${PLUGIN}
	${CLI} plugin:store:clear ${PLUGIN}


