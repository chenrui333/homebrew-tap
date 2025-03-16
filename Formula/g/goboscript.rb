class Goboscript < Formula
  desc "Scratch compiler"
  homepage "https://aspizu.github.io/goboscript/"
  url "https://github.com/aspizu/goboscript/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "79a2749dbcaa6420c0a17f6259a7ba80cd7fedeec7360e1cc217d6c8e114ae96"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d34918ff0577c7cbaaf91602621d5915d8771bd429eb14bf45a3cb547cc888f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4250a44406801ff3e04e0e05e07b522e9ccd855118ca771725595e0cc973af84"
    sha256 cellar: :any_skip_relocation, ventura:       "b48055107da2111fd734574e3b5b5ae454a98addb59307fdf775d9a70cd034ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48ff41e3586e420cb39eb574e850d1ca6196ab3f9307a489e9eb75ddc2eb993d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"goboscript", "completions")
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
