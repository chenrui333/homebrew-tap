class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.94.2.tar.gz"
  sha256 "a34320ea215746f08631bfeedb93b31bc55e733c1b5f1bb03d53e3267e081455"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5155bfb9e9c46f488a3524be362966b8afd12f479282eae03abef472730f871"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a90d466ae9dbbc8d2ea9f968b54094ccc737d60fdc1b6c78a333c518d2cff0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6aef5737e9a40d9a12c996af0a6d978fa9651e0b55734032ac643818ea734243"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f5ea8fff32a608bc2a9285d4d400ac8b60647b31055d6e0d6576e52ae02c3df"
    sha256 cellar: :any,                 x86_64_linux:  "66b8b23ce0a6e65a85f3406b8f0415249c452d4ee9c8409d0530bdaeaefc4d9b"
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
