class Prempti < Formula
  desc "Falco-powered policy and visibility layer for AI coding agents"
  homepage "https://github.com/falcosecurity/prempti"
  url "https://github.com/falcosecurity/prempti/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "f32b7fb7a89087552cbc5b716ad72187ffccee39bfa9f0230ca3cc47af170067"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/prempti.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5b4fec4bc3fa9763a7df41169eb39b6f703ae1f3ad1918cedbd45f3bf27d69a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "687b07b79dd1f198052468caa79ef9b861375d0950c968376788d28e2816be9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1de0f8a12ef3d5c7929f8ada807b1f3a8a588289f214ddc172bcc11057421655"
    sha256 cellar: :any,                 arm64_linux:   "419e0d02b4fa9f7067b47a6f7122222f83f1adf595f832d8af080ed336705fe3"
    sha256 cellar: :any,                 x86_64_linux:  "2d76894b2c7513b6a85cba526fe8302a0c8cf1fc7e9f5d823720e6fa30b59ba9"
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
