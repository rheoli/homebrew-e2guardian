# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class E2guardian < Formula
  desc "Fork of Dansguardian Project with many improvements and bug fixes, e2guardian is a web content filtering proxy that works in conjunction with another caching proxy such as Squid or Oops"
  homepage "http://www.e2guardian.org"
  head "https://github.com/e2guardian/e2guardian.git"

  depends_on "automake"
  depends_on "autoconf"
  depends_on "libtool"
  depends_on "pkg-config"
  depends_on "pcre"

  def install
    # Formula fails when building in parallel
    ENV.deparallelize 

    # NOTE: Taken from autogen.sh; 
    # Using 'system "./autogen.sh" fails because it can't find 'aclocal' even
    # though it has been installed.
    system "cp", "README.md", "README"
    system "aclocal", "-I m4"
    system "autoheader"
    system "automake", "--add-missing", "--copy"
    system "autoconf"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test e2guardian`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    #system "false"
  end
end
