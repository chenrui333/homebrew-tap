class Csvi < Formula
  desc "Cross-platform terminal CSV editor"
  homepage "https://hymkor.github.io/csvi/"
  url "https://github.com/hymkor/csvi/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "4604cbe29abd2467425bd386960f72dae6d67096522fbf6b0c6705c8c7cc5314"
  license "MIT"
  head "https://github.com/hymkor/csvi.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "c1deff371ea51b98088597994f2569b0d213e40bfba08b6b2ac44f3d1a6b0e23"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd57713bfe66ba8107a93efa6a9894b067fca2688f67cf3a92130133f1107b59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd57713bfe66ba8107a93efa6a9894b067fca2688f67cf3a92130133f1107b59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8f000e1a501df45e29dde899f62e18ee27d33278e3775baaea490877cb90bf6"
    sha256 cellar: :any,                 x86_64_linux:  "e97ae12cc5351c72dbe3c57f3b69847d8c2084c7b579fb6cf969f197c5bfa6bb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/csvi"
  end

  test do
    input = <<~CSV
      name,score
      ann,1
    CSV

    assert_match version.to_s, shell_output("#{bin}/csvi -version 2>&1")

    output = pipe_output("#{bin}/csvi -auto 'w|-|q|y' 2>/dev/null", input, 0)
    assert_equal input, output.gsub("\r\n", "\n")
  end
end
