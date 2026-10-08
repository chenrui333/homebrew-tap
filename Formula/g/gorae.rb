class Gorae < Formula
  desc "TUI librarian for PDFs and EPUBs"
  homepage "https://github.com/Han8931/gorae"
  url "https://github.com/Han8931/gorae/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "5922ff240de97c4f8e842395b14d0a255821387684c570f818e483eec09b7406"
  license "MIT"
  head "https://github.com/Han8931/gorae.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "355e68395d45cdc0072c7229dafcaf35a29ab47cb7c1833c9133d7891d0ac46f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "355e68395d45cdc0072c7229dafcaf35a29ab47cb7c1833c9133d7891d0ac46f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b9205634e686561589f68edafe6312ee7de623419dd2c6975469e72984a7def"
    sha256 cellar: :any,                 x86_64_linux:  "962b44f93146e1186cd1c86776b623dec2750555e3c038d4084d30ab6e22fa8b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gorae"
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"gorae", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
