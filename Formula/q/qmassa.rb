class Qmassa < Formula
  desc "TUI for displaying GPUs usage stats on Linux"
  homepage "https://github.com/ulissesf/qmassa"
  url "https://github.com/ulissesf/qmassa/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "95818b11e5f5de8514389c6076090cdcd01ea1e970a9ab5cf63920d4688cd070"
  license "Apache-2.0"
  head "https://github.com/ulissesf/qmassa.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "23aa4e9ac7b02ae2a62d396ad1b92aec278ef8cd59d7cd1af258c7e6c2a343d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5b8871e55b502871c1d056cbe8729a070ef984b57dbc5ce389abdd4f110bb1f3"
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
