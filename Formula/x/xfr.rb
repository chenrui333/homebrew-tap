class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.10.tar.gz"
  sha256 "6c9b57d823d91b24bd3201488086cd697cbec9575a94eecf90c751b7e204aef9"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3291062998502fbefec508520f817f9263ff13a6ec4e6dbd88785578265982cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc5854c7c052962cb5824ed1dcd521f32120d45c1958de5fd070625232fdbb34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9390d4f5ee7aeac5635eda9c0b5de38f59e24bfde0a1b328879c4741201b3f31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f779cffb6f4ec05258a7c55763bcd74ebfc8b156292bb5b95c6251faca642d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0246d6d3ad6b3cc32a0f305a0a10c62895e5b14ee2a545a34f0ccbb05c16096"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"xfr", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xfr --version")
  end
end
