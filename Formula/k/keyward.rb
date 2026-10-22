class Keyward < Formula
  desc "Manage SSH keys and audit SSH configuration"
  homepage "https://github.com/gateway-of-last-resort/keyward"
  url "https://github.com/gateway-of-last-resort/keyward/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "2bafd0effc9da8acbb1c08c3f5739b7894547c3e0fdf44d0ff8a1aeb487d904c"
  license "MIT"
  head "https://github.com/gateway-of-last-resort/keyward.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4076c371d91127611e9663405202e87e059c52fdd68588d2fcc32c3e14a701ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4076c371d91127611e9663405202e87e059c52fdd68588d2fcc32c3e14a701ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b40fb66689d15ffc792e664510c840c2bd59ef0f47f45f715098404dd184701"
    sha256 cellar: :any,                 x86_64_linux:  "ed76055179b21a597bc8144dd39edd30872f1cdeb07281be80dc614232c38225"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/keyward"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/keyward --version")
    (testpath/".ssh").mkpath
    assert_empty JSON.parse(shell_output("#{bin}/keyward list --json"))
  end
end
