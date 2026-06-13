class Croft < Formula
  desc "VSCode-style TUI text editor"
  homepage "https://codeberg.org/vitali87/croft"
  url "https://codeberg.org/vitali87/croft/archive/8b6e7e0e26cded417b386a4f0cd2e1a5fb9674e0.tar.gz"
  version "0.1.347"
  sha256 "32dd8364251158856dde56ae96925c53c8a936a00e518088187ab10d7fb12b61"
  license "MIT"
  head "https://codeberg.org/vitali87/croft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cec77a21ba27835313cb732a8477e0285c17adfb192313ea947343463c3307c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "295601d2c1cf412768617acbdff840e537bc1f755815f1d3c0322852e51e05d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c656b81e78af2cb62ca6776995cc2c3d849054ecdce74ed220ce774029350b1"
    sha256 cellar: :any,                 arm64_linux:   "b7d63b7a1c753caff0438b13fddb9a8c8ba9d7cd64c747d8e9ccab765809e986"
    sha256 cellar: :any,                 x86_64_linux:  "375bddc5e80906651d86309a8db0a0e822003fa7de945eda023a507738de9c95"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/croft --version")
    output = shell_output("#{bin}/croft --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
