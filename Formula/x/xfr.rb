class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "da4c4eb260f45165596821c954fc327ddff37a5745cc9688ac1477022a6b7cd5"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c78d86670c06a8e1374fa305309dd09f53fe4687f050d3b87330a5040eb067e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f28dbc3312b84fa6183e8fbc350556f23fc960ec1babfe817b6220f8b346c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdb36f876a8f80418ab863cfae12e6256c223787fb713773b341c828492ffbb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa855e1f32bba2f774730bfa93cf62d2fa82871950da13fb063817d94377f9e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ad31b4374a1f4b0c98e39e8df9e5539ba0bc2711a0afa4dac76fad845af5199"
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
