class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.19.2.tar.gz"
  sha256 "c01de954213fc18bdc26b40e5a44791683abec00c56104e2f9907b258d36c34b"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f26bfce9ab169c67bd7d918dad09e21f67c46b95fd25768689e5679f3e6daaec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f26bfce9ab169c67bd7d918dad09e21f67c46b95fd25768689e5679f3e6daaec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3d04a27733e33d0d61fdaa56776ea6bd3b2bfffc912c31a12eb42fd856cc2c2"
    sha256 cellar: :any,                 x86_64_linux:  "60e76af7841ea3c70f7aa1783e5554e1e09ced1a7fea59d96094be0177d74c08"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazyjira"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyjira --version")

    output = shell_output("#{bin}/lazyjira auth </dev/null 2>&1", 1)
    assert_match "host is required", output
  end
end
