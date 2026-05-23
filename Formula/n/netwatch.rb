class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "acc6199bcce8916295f95b491548e18f4e5c0227afb22506529819dea9cd2acd"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dd3e157d897d1db592d914c19540303de105af20bcf8ff26ca429c40c51806a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50168f0ae8ee19290f75943e6901bc4fb00b3437d5be31bc1aa1346c94a59280"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f466e744d5ee21fb2c6af984311848537b2430205aaa75760c68d3e7d28bf19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bdf112da0b51b3992ebdad1516393d69161e62efb6ce360cae9c7e4c5a1a3f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbe3a1eb617f66a8e87fa603c2daa52e9dd5565af70799b29f01e79046b8e797"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "netwatch", shell_output("#{bin}/netwatch --help 2>&1")
  end
end
