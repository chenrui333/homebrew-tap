class Lazytilt < Formula
  desc "Terminal interface for Tilt"
  homepage "https://github.com/tdi/lazytilt"
  url "https://github.com/tdi/lazytilt/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "7670e7436f241b2d8fbf9a3f7dd12bf21b04de8b995161a38ccb5dd3c590a889"
  license "MIT"
  head "https://github.com/tdi/lazytilt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1994921c3a1c60c3428740cc74f4be100ecb5e8a36aeef357f266d2045fa150f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1994921c3a1c60c3428740cc74f4be100ecb5e8a36aeef357f266d2045fa150f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c067b9f568f17a4dc06dbdd36c07a620daa13a79e94fdfa634d85b4b054d5e3"
    sha256 cellar: :any,                 x86_64_linux:  "b32b1f600025b531f98defe8d397d242e54a9b0c1680935000bbca3aa00f3e4c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazytilt --version")
    output = shell_output("#{bin}/lazytilt --invalid-option 2>&1", 2)
    assert_match "flag provided but not defined", output
  end
end
