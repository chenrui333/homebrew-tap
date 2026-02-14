class Goboscript < Formula
  desc "Scratch compiler"
  homepage "https://aspizu.github.io/goboscript/"
  url "https://github.com/aspizu/goboscript/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "6c8de14efeabf33d64db7b17d81718b585a221a09db2422b72eb82eeed817664"
  license "MIT"
  head "https://github.com/aspizu/goboscript.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b5b290bbb428bc91a8d847d31f7167d43e48d1a8820079ee0a648af40278891"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8582390c67f108f8e190204349c35b6de2d5a0600b57923177a28686bd4b249e"
    sha256 cellar: :any_skip_relocation, ventura:       "d60399c17e006ee18f1934edfebd375bdbc6aac6c74f5a1e4a6ad41839e2db0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c314fe72b518a14cb010d7ee1ac9b4957a1d8c2312caa265661c381d44c3f52"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"goboscript", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goboscript --version")

    # test scratch file
    scratch_file = testpath/"test.scratch"
    scratch_file.write <<~SCRATCH
      when gf clicked
      say [Hello, world!]
    SCRATCH

    system bin/"goboscript", "fmt", "-i", scratch_file

    system bin/"goboscript", "new", "--name", "brewtest"
    assert_path_exists testpath/"brewtest/goboscript.toml"
  end
end
