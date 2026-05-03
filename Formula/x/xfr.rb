class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.13.tar.gz"
  sha256 "7558b36105eae7a7398f2e550dd04f5254bb48571541a4a9e5dee5f3f467c4de"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02305acd3350376335d687685dfb0735ab809d25c8389a3433417015d1a37079"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "929d8774ec380fe86cd80529671d38fb88f16e7c6e255c88a55fc8d1842da4d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "533003d3c373e1b8a73e38869e5cc0b6830440e512acbdc457dc8709805af9e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd94c688038f5d3e434af928a2b2985d5a0138ea1d402ce20f59c8fd101d7669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33d74f99f2c1c86248055bd675f7af3ba95421fc893aeb906efc3c50b7b47977"
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
