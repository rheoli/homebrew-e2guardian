# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class E2guardian < Formula
  desc "Fork of Dansguardian Project with many improvements and bug fixes, e2guardian is a web content filtering proxy that works in conjunction with another caching proxy such as Squid or Oops"
  homepage "http://www.e2guardian.org"
  head "https://github.com/e2guardian/e2guardian.git"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    # Formula fails when building in parallel
    ENV.deparallelize 

    # NOTE: This requires the `depends_on` clauses for automake, autoconf and libtool
    # It seems like Homebrew doesn't include the paths to these, even if they have been
    # installed, unless you say that they are depended on
    system "./autogen.sh"

    system "./configure",
        "--disable-dependency-tracking",
        "--enable-locallists=yes",
        "--prefix=#{prefix}",
        "--localstatedir=#{var}",
        "--sysconfdir=#{etc}"

    system "make"
    system "make", "install"
  end

  def post_install
    (var/"log/e2guardian").mkpath
    (var/"run/e2guardian").mkpath
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

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_sbin}/e2guardian</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
