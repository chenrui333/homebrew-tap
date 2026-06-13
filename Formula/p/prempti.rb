class Prempti < Formula
  desc "Falco-powered policy and visibility layer for AI coding agents"
  homepage "https://github.com/falcosecurity/prempti"
  url "https://github.com/falcosecurity/prempti/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "87671d3ee65bed1a37d0ab884f1d3db2600111263b69a76f08b683f67236cd9f"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/prempti.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "782bb73506376dba7964d9b4393b23192e36bc02adfb950a36ba4482dc577edc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2eb3885d1393bf0f2007d1ea35a720afc51103abc5b8ec3bf434c09472446c4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0d8f5dfbb008ae8800cf2fff45611464594a013b3295e66b39e261fd4aaf585"
    sha256 cellar: :any,                 arm64_linux:   "f53a47819de3b4d4b744ddb6ea632cbf8fb5d60898a1f64b1fdc6f7a457ecc39"
    sha256 cellar: :any,                 x86_64_linux:  "a18980856acd89ebae2215b05283032e21b54ca9496a46a7b727ffeb41b07f78"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "tools/premptictl")
    system "cargo", "install", *std_cargo_args(path: "hooks/claude-code")
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    output = pipe_output("#{bin}/claude-interceptor", "{}\n")
    assert_match "permissionDecision", output
    assert_match "broker unavailable", output
  end
end
