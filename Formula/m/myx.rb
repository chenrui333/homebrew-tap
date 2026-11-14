class Myx < Formula
  desc "Terminal Spotify player"
  homepage "https://github.com/HaseebKhalid1507/Myx"
  url "https://github.com/HaseebKhalid1507/Myx/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "6b4b6263d27097c84c0659d21c40b6d7f842d3c39cd722a7f3d2633c3139938f"
  license "MIT"
  head "https://github.com/HaseebKhalid1507/Myx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "086bd02ba6dd427020ab9d8586337069b615f6924e4a1844ed2776406ae2c77c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b20b771076b3f05d3a031371d29ef94f9b4cd187e949a65be34e12e4cfe15d50"
    sha256 cellar: :any,                 arm64_linux:   "005a53523bad37a57d97d5fb00b9a7867337594e53c3272d2790922650c72c87"
    sha256 cellar: :any,                 x86_64_linux:  "ffe6bc7a3fbb064240039cb7b0de1eadea59b526d4b83705a96011e60bf0d92c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # TODO: Upstream does not expose a version command; add a version assertion when available.
    output = shell_output("#{bin}/myx theme get --format invalid 2>&1", 2)
    assert_match 'unknown format "invalid"', output
    assert_match "expected sh, css, hex or json", output
  end
end
