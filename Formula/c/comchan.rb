class Comchan < Formula
  desc "Minimal serial monitor and plotter for embedded applications"
  homepage "https://github.com/Vaishnav-Sabari-Girish/ComChan"
  url "https://github.com/Vaishnav-Sabari-Girish/ComChan/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "1e1b8788d2d2de5ab5685248355cb3b4e4ef41901b6735e2541ffeef0d99fab3"
  license "MIT"
  head "https://github.com/Vaishnav-Sabari-Girish/ComChan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef1f873edd46b9472afbff4c345098df7ea2ba913f2085bf45c88fb9a39b04d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5794641eb60b4987921f27df554ee9290e23c793f7364b9daed2065f9b9d8fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3fe3132e85bb61d15611adb3520121b4c3f8a6894cf817fb3adc85c18adc036"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "927ec14e6bde9c5f5ed966762a4a37e65d0e2c2da6aa7d193f1da8fa137c24ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62c2bf3aa05a02be5960949f0d2b99acffd3414e18a35b010e5a2bb16576a7be"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/comchan --version")

    shell_output("HOME=#{testpath} #{bin}/comchan --generate-config")

    config = if OS.mac?
      testpath/"Library/Application Support/comchan/comchan.toml"
    else
      testpath/".config/comchan/comchan.toml"
    end
    assert_path_exists config
    assert_match 'port = "auto"', config.read
  end
end
