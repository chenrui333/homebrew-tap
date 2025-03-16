class Goboscript < Formula
  desc "Scratch compiler"
  homepage "https://aspizu.github.io/goboscript/"
  url "https://github.com/aspizu/goboscript/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "5e456ae052105f28b9b68152d1e09896a76da67e6bba12aae19a6d616958809c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ef2981d2b7bc01637f69ca5ff9835818f6954d4044db0ecc35f92548d10d211"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec3381bc6a799db32282efa44e08b3b9c235b41491aab1c4f92eb2f68e534321"
    sha256 cellar: :any_skip_relocation, ventura:       "ad68ec5be18fb1813553107f8ec718ed24d9d88d225fc87a29d6058360c61da5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3382aeed8caedafefd8282f8223ec889bc4138a4d8b72573dd6582ff4e2bf63"
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
