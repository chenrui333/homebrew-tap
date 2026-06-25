class Unifly < Formula
  desc "CLI/TUI for UniFi network controller management"
  homepage "https://github.com/hyperb1iss/unifly"
  url "https://github.com/hyperb1iss/unifly/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "c8aef27d8efe71f3f337be7e21e7e7a54ee33b616b67b729a05b0d87904d9592"
  license "Apache-2.0"
  head "https://github.com/hyperb1iss/unifly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae1dc3ec88848b8e2f2927096d50b27bd2149e21b1089ca424a218133cdcf63d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "082e8f94eb6d7023fddb61a1039eec5cfebcd26329e8fe05d0c245bc26986474"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50738900480eec146339491c251aaec223d9b41a5e4836f286808660900dc116"
    sha256 cellar: :any,                 arm64_linux:   "3950744df4746f39c8f456d1aa886654922ad7b73a85e14a97c5107120d45e81"
    sha256 cellar: :any,                 x86_64_linux:  "832f934a651a7c5a257bdc3459ca46c10b5bcb05d95048ce93928840f8fbe269"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    (buildpath/".cargo/config.toml").delete if OS.linux?
    system "cargo", "install", *std_cargo_args(path: "crates/unifly")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unifly --version 2>&1")
  end
end
