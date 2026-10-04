class Jsmin < Formula
  desc "Minify JavaScript code"
  homepage "https://www.crockford.com/javascript/jsmin.html"
  url "https://github.com/douglascrockford/JSMin/archive/430bfe68dc0823d8c0f92c08d426e517cbc8de5e.tar.gz"
  version "2019-10-30"
  sha256 "24e3ad04979ace5d734e38b843f62f0dc832f94f5ba48642da31b4a33ccec9ac"
  license "JSON"

  # The GitHub repository doesn't contain any tags, so we have to check the
  # date in the comment at the top of the `jsmin.c` file.
  livecheck do
    url "https://raw.githubusercontent.com/douglascrockford/JSMin/master/jsmin.c"
    regex(/jsmin\.c\s*(\d{4}-\d{1,2}-\d{1,2})/im)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "622cade7e3e8816a366c1c3b49527b418008f8904c39bfe730b3b707829bbb57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce516e3a5be152bc2e05cf6d516949758382d2b6aec68c059c12e80451152766"
    sha256 cellar: :any,                 arm64_linux:   "ce3519d027676799b8948d2aa6e1fd2bd8bc021f417d4a894eaf816950a66048"
    sha256 cellar: :any,                 x86_64_linux:  "ccac641104331ef9bde6979c6c645a78f71d71b4da943b061de9e50367cecbe5"
  end

  deny_network_access!

  def install
    system ENV.cc, "jsmin.c", "-o", "jsmin"
    bin.install "jsmin"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace with a version assertion when available.
    assert_equal "\nvar i=0;", pipe_output(bin/"jsmin", "var i = 0; // comment")
    assert_equal "\nvar url=\"http://example.test\";",
                 pipe_output(bin/"jsmin", 'var url = "http://example.test";')
  end
end
