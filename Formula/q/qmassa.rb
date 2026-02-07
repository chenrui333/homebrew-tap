class Qmassa < Formula
  desc "TUI for displaying GPUs usage stats on Linux"
  homepage "https://github.com/ulissesf/qmassa"
  url "https://github.com/ulissesf/qmassa/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "54130e61b7f3494cf741c2fc0d8f2418d8bfc3c97bbc3da236c49d0e8f6cf564"
  license "Apache-2.0"
  head "https://github.com/ulissesf/qmassa.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "ad1f4de97407f64b94182ee6e68c2abeca225d924cbd6dc35e2ce69e2d0a07d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "553fbd39381d202066f2a31e35418cc4fe49d427ed08612501da8253a20c6a4a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on :linux
  depends_on "systemd" # for `libudev`

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
