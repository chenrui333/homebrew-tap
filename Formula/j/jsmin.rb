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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93757b601416b1fce07734b4d4575e15c549a46ef8a917df70ef6da0795334d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "723a0107278c71d30ecaf8dcb17fb1705c07dd87fac13b7c137bea7e38ea02e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c77754462fa35edf5ccb67813c717fa214ee0edc811aa1ca43d985d99be58a3"
    sha256 cellar: :any_skip_relocation, sequoia:       "815d140009a9dfcf3a51f653ad71f7355e4b4d544442a44ccd65f40f84c82389"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f18e0d4c70c99f24e52fa465c0856058d0f1be6c1a5e9befec570e97e38cd60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f22ba0914678b286970f10889ad477085c917e247ccfeaa9016bdafea2939dd6"
  end

  def install
    system ENV.cc, "jsmin.c", "-o", "jsmin"
    bin.install "jsmin"
  end

  test do
    assert_equal "\nvar i=0;", pipe_output(bin/"jsmin", "var i = 0; // comment")
  end
end
