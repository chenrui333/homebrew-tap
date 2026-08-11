class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.2.56.tar.gz"
  sha256 "5e472338cb9cc29b6224007edd29c577bc1d422200d2970200b415df06c09a5e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bdda94957dbb8eb197f1df24c8d28f80c9522a6b0d5657d8ca4bd6040fb1b27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "984a20c24578f20dff53367a1e3d5a59f6ffd1c9fbb4e258209f4b3cf5e0e5f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "462d46dc1676d7bf9162d1918095f2384ba2a2a9b213e3f317c96403da600dd0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"

  def install
    system "cargo", "install", "--bin", "datui", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/datui --version")

    output = shell_output("HOME=#{testpath} #{bin}/datui --generate-config")
    assert_match "Configuration file written to:", output
  end
end
