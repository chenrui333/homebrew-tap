class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide/archive/refs/tags/0.23.0.tar.gz"
  sha256 "901f1de739eb026e24f5f929665d1d9b004c2030b6e2d8a4ba989902c5782351"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9d7f54778bf236937de2ae207ee6b508e91714e7ffbe9b2b80c517f08ffac5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff429e730fc882708b95833e7a2077c90a6ffb3f3c6922564ddb9b20d4e2b05f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e9d4d298e076508b51666280a26af6379f2c19a2051d64d6f038780b8777513"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ba8d085449ef08e539c9b09a10412fb93189e5f41b6d484ec6c402fc04544b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be96277fef16006a77098f8ec91f57b11f094cf90b2949a24bfffcda4df76cf5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termide --version")
  end
end
