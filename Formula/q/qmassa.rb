class Qmassa < Formula
  desc "TUI for displaying GPUs usage stats on Linux"
  homepage "https://github.com/ulissesf/qmassa"
  url "https://github.com/ulissesf/qmassa/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "a65763543858b7042d91756bbd9afe45a3c3dddea7b845115e9e8ba4625044f3"
  license "Apache-2.0"
  head "https://github.com/ulissesf/qmassa.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c345181198ce564414e823649c0c07e85e68f67c183d8b82472c504809005de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cd023225c2e3f973e379307487febde9651f285d2e82c59b1e608b6ba7971b49"
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
  end
end
