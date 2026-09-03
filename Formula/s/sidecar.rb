class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "4495aff770abd7092947d5557cec971361cb777ad3f13286b9dd3118c74753f9"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d875a53468b9e28e19413e434931f3e6144b7091be086dd4acd0702931de4c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "557a7f16f8315979b3c11deec1707d10929221a39ba058835cd5b19006704471"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de761e56a9fd51ef87d935feccfa6fe58ad60c490bf3bfadbc101259f9d25b81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b42db0f006a9b5a6feae7db07e1b55ed882d2dd3c4082294e1b98405a92c07c1"
    sha256 cellar: :any,                 x86_64_linux:  "9047a46fbf1ac1eaf611cf1db8ca30900295a033a65302ce1a2a92be12c15b42"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"sidecar"), "./cmd/sidecar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sidecar --version")
    assert_match "Sidecar requires an interactive terminal",
                 shell_output("#{bin}/sidecar --project #{testpath} 2>&1", 1)
  end
end
