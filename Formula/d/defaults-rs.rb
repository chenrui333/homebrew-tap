class DefaultsRs < Formula
  desc "Open-source interface to a user's defaults on macOS"
  homepage "https://github.com/machlit/defaults-rs"
  url "https://github.com/machlit/defaults-rs/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "4e62e37fdd4bb0c7d14c59d0f825ab8d24356a211bd401025973691e122359df"
  license "MIT"
  head "https://github.com/machlit/defaults-rs.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9102cae97ca71eefd11b3af5af1edb09e3c02a005b47835e3a5a2f43a8429b98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab241b11e45dac1733721d6303c2fa26ce4194dd6eb62349744bcd1bc53f929b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "893a7e1e53b5574fb4abca11da6aa53f846e70941e492b6700b070e087b3806f"
  end

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drs --version")

    locale = shell_output("#{bin}/drs read NSGlobalDomain AppleLocale").strip
    refute_empty locale
  end
end
