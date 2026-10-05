class Myx < Formula
  desc "Terminal Spotify player"
  homepage "https://github.com/HaseebKhalid1507/Myx"
  url "https://github.com/HaseebKhalid1507/Myx/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "42c48a29910a44bca6eef52692a7f3774c80ceffed2c11c7a6b541b8cca645e3"
  license "MIT"
  head "https://github.com/HaseebKhalid1507/Myx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "741cc2dcec54ed850aefac987717963b30d758164eddf894356ca39d19dd7ee8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "729f966631441f61b784c5aa745ae13ea874b0d32c1f48b27541c03474551a7d"
    sha256 cellar: :any,                 arm64_linux:   "2326d2e0602e74d6d797ff1f471d67e45d25610fafccfce498fedac1affeaab6"
    sha256 cellar: :any,                 x86_64_linux:  "6afb6c39c3949877c72a458704de6df2290c8207b2fe1847e3d58d973f4619ab"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # TODO: Upstream does not expose a version command; add a version assertion when available.
    output = shell_output("#{bin}/myx theme get --format invalid 2>&1", 2)
    assert_match 'unknown format "invalid"', output
    assert_match "expected sh, css, hex or json", output
  end
end
