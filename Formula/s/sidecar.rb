class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.89.0.tar.gz"
  sha256 "0163a47535de22f0a8060eb6febec03dfaa7bc759a15363dd3e30a0b3ea9982d"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d1fd25a5fa0640801b8ec7859084133ba7ea5dff40c005b4964384e272ef62a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40fba763808adb024ced729d8ec168a5cd9404b530ed76bc2b3b7568cdd80ed5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef550a13d710312d9f49ddcc927a1816bdefcce29dd5ea2a7f1818c1f2d42db8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8d4728675f58564d1a0a1b7806aea90248af25bfb65abe67a45da6b3afe7a08"
    sha256 cellar: :any,                 x86_64_linux:  "af511e6fd55f45649cfd9e87456a70bd2e043fc646da25749099e5780cc2f9d8"
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
