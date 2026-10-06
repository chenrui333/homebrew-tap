class Qmassa < Formula
  desc "TUI for displaying GPUs usage stats on Linux"
  homepage "https://github.com/ulissesf/qmassa"
  url "https://github.com/ulissesf/qmassa/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "54130e61b7f3494cf741c2fc0d8f2418d8bfc3c97bbc3da236c49d0e8f6cf564"
  license "Apache-2.0"
  head "https://github.com/ulissesf/qmassa.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_linux:  "a9added0dc0124a794a8499a658aed391a1228cf1fedaa9d614d13bb0a33b967"
    sha256 cellar: :any, x86_64_linux: "d0389dc1987d066ae41917bb805566752e398ad676dec97bf5283c5c0a3832ac"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on :linux
  depends_on "systemd" # for `libudev`

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qmassa --version")

    # Fails in Linux CI with `No such device or address` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "Error: No DRM devices found", shell_output("#{bin}/qmassa 2>&1", 1)
  end
end
