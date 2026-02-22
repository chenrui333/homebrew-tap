class DefaultsRs < Formula
  desc "Open-source interface to a user's defaults on macOS"
  homepage "https://github.com/machlit/defaults-rs"
  url "https://github.com/machlit/defaults-rs/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "4e62e37fdd4bb0c7d14c59d0f825ab8d24356a211bd401025973691e122359df"
  license "MIT"
  head "https://github.com/machlit/defaults-rs.git", branch: "master"

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
