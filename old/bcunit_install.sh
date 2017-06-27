# Maintainer: Daniel Milde <daniel at milde dot cz>
# Contributor: Danibspi danibspi <at> gmail <dot> com

pkgname=bcunit
_commit=29c556fa8ac1ab21fba1291231ffa8dea43cf32a
url="https://github.com/BelledonneCommunications/bcunit"
options=('!libtool')
source="https://github.com/BelledonneCommunications/bcunit/archive/${_commit}.zip"
pkgdir=/usr/local

workdir=$(mktemp -d)

download() {
  cd "$workdir"
  wget "$source"
  unzip *.zip
}

build() {
  cd "$workdir"
  cd "bcunit-${_commit}"
  [ -x configure ] || ./autogen.sh
  ./configure --prefix=/usr
  make
}

package() {
  cd "$workdir/bcunit-${_commit}"
  make DESTDIR="$pkgdir" install
  mv "$pkgdir"/usr/doc "$pkgdir"/usr/share/doc
}

download
build
package
