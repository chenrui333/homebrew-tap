class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.25.9.tar.gz"
  sha256 "5abd1601b3b50313da0778f97b8fc2c7b8fc8a863340cfb4ee40b7c131463134"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efbff3d38d3611912405001d9f0959b13b573b799aa3d1dca2d2c32371234055"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9349603f65080c27bd0816cc97b4195478d6add42f5adaa97ca5030f9790bddf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6b93728befb0fcf1f8044793fb357af8b53a0ffd5fcf6ae4647c10d38e9d2f8"
    sha256 cellar: :any,                 arm64_linux:   "61dacc188f454294daecad13bc338226994d9043d5d15ea6e5733c20ffb0172f"
    sha256 cellar: :any,                 x86_64_linux:  "1c8045c1a8feff172aac289b8c8ed3d97c2cfd4fc51844ccfe6f549a9c719957"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netwatch --version")

    output = shell_output("#{bin}/netwatch --generate-config")
    assert_match "Config written to", output
  end
end
