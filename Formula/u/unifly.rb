class Unifly < Formula
  desc "CLI/TUI for UniFi network controller management"
  homepage "https://github.com/hyperb1iss/unifly"
  url "https://github.com/hyperb1iss/unifly/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "34a5c73a548270f670b9458f07da3ba1a94f1b9c31831fd4c433d6e01d561330"
  license "Apache-2.0"
  head "https://github.com/hyperb1iss/unifly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bf050bea8864fb26bc64205d53179318a988af05b59f125887d862c768bb328"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5a47ccb3790b22ca6450efa8146be1db9a0cdbd997249d413d9d6b999aaf377"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58812235ace7cadd97733db8ee79bc6c75d7e7a754db84f2739e1ffa9fa38549"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79c2752c167cdd7d7e9a026e89a8a0dfb1f0d4a2b876d3b8fd0fff680913ee02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75d038e8dd3396ae3c6ff58ce66073cf2101cae8321fa48d32167f6da9043d8e"
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
