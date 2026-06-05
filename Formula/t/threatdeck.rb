class Threatdeck < Formula
  desc "Terminal based threat intelligence monitoring and alerting platform"
  homepage "https://github.com/gripebomb/threatdeck"
  url "https://github.com/gripebomb/threatdeck/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "eca039c274ffc0c1f121d2f5f22f68d070011b2754819aa7a6ed58e50c9b5b7e"
  license "MIT"
  head "https://github.com/gripebomb/threatdeck.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d7e0e4d4bf0d1d1af10e9e10922985377b31bff2b77f284375b2ac5d3022003"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "250362b252a42ef89028414755ebfdebd845a9b2a65388701e34d5cadfc19c9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f62b8b22d8efc8ce8352f3dfac0b9b92afba4f6b21d88b557d4fdb6de991eb53"
    sha256 cellar: :any,                 arm64_linux:   "4712cb9fc34eceb53dbaf405c7990718f59f2d158f016e65711949662763bb24"
    sha256 cellar: :any,                 x86_64_linux:  "86079c16f647821617cc31030ee414828fb5e408f70e71db84b852589b86a2a6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ThreatDeck --version 2>&1")
  end
end
