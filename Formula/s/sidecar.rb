class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.80.0.tar.gz"
  sha256 "36e08e237ab47772b819fdb58f81bc527af7148b4c195c7dcaa011851bb2c0b9"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f40c551793cecaa97da2d77991c777add2539fd466feeb8930f41480ef3be6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2e4e8d170d6d75e2d7df28994c38d1d5f874ee8a818ef3f43eb9d0b33de6146"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3115c778b0ac5f271059b48d10b7aece779de929646ebae18d8f723eb55bcc63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8f7a8eee2c85f2f55a624c08a1022ea47c824f754654fd7e67cce6a3ed6ebec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ed22110047d40b9611d1839612d471faf67633ca6f8074e3bd6e1ec30580ebf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"sidecar"), "./cmd/sidecar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sidecar --version")
    assert_match "sidecar requires an interactive terminal",
                 shell_output("#{bin}/sidecar --project #{testpath} 2>&1", 1)
  end
end
