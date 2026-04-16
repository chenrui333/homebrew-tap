class Macime < Formula
  desc "Blazingly fast IME switcher for macOS"
  homepage "https://github.com/riodelphino/macime"
  url "https://github.com/riodelphino/macime/archive/refs/tags/v4.4.2.tar.gz"
  sha256 "f9257fe9ac84a9650533645290f99e3d7e7d928de9a88afa280037e779f84794"
  license "MIT"
  head "https://github.com/riodelphino/macime.git", branch: "4.x"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5eeaa20e11534ed122147ab3da966ea5405a7ce3bcb16394cfb781cb66a13695"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73e3db362ce0e911cb13aae8583ea1ab246725aec5d3fbaa48b417855f16efd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdf36779135b2770f5258f211ee92fa98c3b44f3f95f2796d1460f336a15ddec"
    sha256 cellar: :any_skip_relocation, sequoia:       "dd3d63f524848aa07999e91eaf51250b228af768e5011e5ba837e0ca01d5c0da"
  end

  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/macime", ".build/release/macimed"
  end

  service do
    run [opt_bin/"macimed"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macime --version")
    assert_match version.to_s, shell_output("#{bin}/macimed --version")
    assert_match "Invalid log level", shell_output("#{bin}/macimed --log-level nope 2>&1", 1)
  end
end
