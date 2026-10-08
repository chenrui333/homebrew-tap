class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "a8611635e8dc4e94af14368b9ebe28f112886b4a14be776a5a45cc9c550f3865"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91e863cc6f216b932d6cd890d04abf4e67fc62a1c630fbb9a19bf5e9d609c103"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9639e91273fe096698515e8d4202bf2076db47981658a215350a89131adcad47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f370fd89972b615a97a784aa1fb0ab090a8149c2bd1f3eba1ba986219614577"
    sha256 cellar: :any,                 x86_64_linux:  "b84ceed0714d00e8f6b7399df635e5c7ee799a822b6eec92416f5ae551cae890"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
