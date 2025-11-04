class Octotype < Formula
  desc "TUI typing trainer inspired by monkeytype with a focus on customization"
  homepage "https://github.com/mahlquistj/octotype"
  url "https://github.com/mahlquistj/octotype/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "5015c5e9a53609ce5554f98c814b37f6dde0e3b3c515b453bfc1e7999d6a66bc"
  license "MIT"
  head "https://github.com/mahlquistj/octotype.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2d699e1f498c55296f6d1079b457665c9db95de5a1da95923df3fe35e20e46d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "674ea32cbe8296db0ef01c289bda3a6c92965d9bfd880841ccfff053916ab405"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "134e6efb10f46849cd6e211ab79910fb0168a03d23e3f129924b8ced768fc468"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1913a94c68007c1659b05134508609c31e0b552dab5da06647be980ca67484ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a5979724b72595ac9228727e315fa2a153587289f3f1ef19bf9da8ab68a756a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octotype --version")

    output = shell_output("#{bin}/octotype --print-config")
    assert_match "disable_ghost_fade = false", output
  end
end
