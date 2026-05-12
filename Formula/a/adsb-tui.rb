class AdsbTui < Formula
  desc "Modern terminal user interface for tracking aircraft using ADS-B data"
  homepage "https://github.com/j4v3l/ADS-B_TUI"
  url "https://github.com/j4v3l/ADS-B_TUI/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "cfaec5443f30eeaa1908b7587695f219ff0b4cdf6c5967047f145fc50ac7375e"
  license :cannot_represent
  head "https://github.com/j4v3l/ADS-B_TUI.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ff549760a83360be5ac5db09ba8b66ea716d1aaabfaf8a5ba244e6996a072e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e9bb138c751b83f0902585856471b9b7a8490dd3120acf83a762814aa38aa62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83565c00671469943f11794f83e30c276dd64b24feecefdec446ba1706fe710b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fd46a66ff776954a6951be11ce63f999eefe756ba1032d25e5b0de3d19dfeb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d09fba54fb86ce9f32455fccc348088162ceaae7f6a921647952dc06de308ed5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "adsb", shell_output("#{bin}/adsb-tui --help 2>&1")
  end
end
