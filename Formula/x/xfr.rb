class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.10.tar.gz"
  sha256 "6c9b57d823d91b24bd3201488086cd697cbec9575a94eecf90c751b7e204aef9"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9725b076abbb187e29facc719e3f45fa7d27557c8cd75a68843dd5d630e05a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7b18b9f4eea5b27b9f34556620aa3487d5cb958375d5ceeb753a808329f7ead"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "100a064452a8050c2f2a78210529673f39dcefbba5053721566a976a668203b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d77f768316f211c701c8b3b2daccb2c3a65c6885d749da81cf7c80eb4e2cdeac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "670684736542250a9d9b32db3c8ca88436d48440cf41bd31081fd1941fdf991d"
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
