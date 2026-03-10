class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "50f3a9442e79bd98b0344250f641301b3aff768ccdf07f4a6b19aa5c89a0ac96"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74fc5c49f39b43cc7aa59e2e0c8085069b2ab849eef11ece8e4c28289762ea19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb342f6b26e23c04f3ad5242e80d1d92ea15afaf38c7ff7417825518e6d91441"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6206fa8704391aaca8754d3ba1dae2f8ea2c60f1dcad60e16ba6ae5613246ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af083af65d80135a7830d63793cfc5419f3062680b52d060f48fc32fc6468185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bca63adff6a14ed9e3699f7cf6efb967e4dfcbe60b00af4a85d044756cec926a"
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
