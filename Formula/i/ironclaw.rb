class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://github.com/nearai/ironclaw/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "d14af1a713c122b0696c7cbe7ba4cd85c4dace700e63a1c772a7f976cd8635bc"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d77c84885523d7cc0caaf50562c76bb9677ba6824acde20d4b7cd7ce38010591"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1738e15b88d52ef539109f6572ff3d41b0da01e85a5f693369dbcd3f38d0df92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5191e0168ec07283f07fac1b0f2b27c0565f220d8cf620c620c626d2c18a3c8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a7e8a5a8600d1219b662bb996700a2e85021d55cf83f04bea83b6cadd2d4690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ed49343d17331c911e90262a0731dc9c07f450230224e903e2df8806a756e57"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ironclaw", "run"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")
    assert_match "Settings", shell_output("#{bin}/ironclaw config list")
  end
end
