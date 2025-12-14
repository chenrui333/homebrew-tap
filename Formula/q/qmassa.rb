class Qmassa < Formula
  desc "TUI for displaying GPUs usage stats on Linux"
  homepage "https://github.com/ulissesf/qmassa"
  url "https://github.com/ulissesf/qmassa/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "738384c96cc015817b384575733f8ead8297c9507d752a9612bfffe95cf8aba2"
  license "Apache-2.0"
  head "https://github.com/ulissesf/qmassa.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "8d2e1c8076e4d366fa7ca0564c82cf5602f3f6a97f9d7a66354d856aa64bec7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ec286cc05520657e844d6e366a678c656ffb422ab866c779792187e34114212c"
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
