class CcFilter < Formula
  desc "Claude Code Sensitive Information Filter"
  homepage "https://github.com/wissem/cc-filter"
  url "https://github.com/wissem/cc-filter/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "41a20564a8abd916c3fbef19153d2514ad40988e78dd33b3cc23dcda68c01549"
  license "MIT"
  head "https://github.com/wissem/cc-filter.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2e49d09b9b8acfd6116a355c90b705b8da812dc2e17a0c6400c3f3f13e17f4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2e49d09b9b8acfd6116a355c90b705b8da812dc2e17a0c6400c3f3f13e17f4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2e49d09b9b8acfd6116a355c90b705b8da812dc2e17a0c6400c3f3f13e17f4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4de9348448e4374a2778a37eb73c67d2a269700c738d7e8170575190dc026c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "430934868ccb6e3488c43f3cf330b3d6d82df8c662cf8cfaf4cbb58dabaee812"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"cc-filter"} --version")

    output = pipe_output(bin/"cc-filter", "API_KEY=secret123\n", 0)
    assert_match "API_KEY=***FILTERED***", output
    refute_match "secret123", output
    assert_path_exists testpath/".cc-filter/filter.log"
  end
end
