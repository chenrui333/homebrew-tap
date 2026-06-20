class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.86.0.tar.gz"
  sha256 "6f01f217d1f425b894e798ecbc8b867d015c218d7235a7abfa8644c83b4f83f2"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a611b7053abaa90915690694c403aed52585c35a94751c79d1b8ff2f10840523"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1959fd7bbd0579d8b2c24bfbbf61024dcf84d28a562ec3266ea5d88930f533c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3120151a2a624bdff15fe36009f4462c254026b0a4b108a09e7be319c158230"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abe3975dd469785dfc19cf2b68a1e327163e9da468194aa310edbcb66dced20e"
    sha256 cellar: :any,                 x86_64_linux:  "e7ac3e1024d74046274e10801e89d9cc5f71a5823e186afdf499ec2738a303c7"
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
