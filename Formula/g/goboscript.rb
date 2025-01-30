class Goboscript < Formula
  desc "Scratch compiler"
  homepage "https://aspizu.github.io/goboscript/"
  url "https://github.com/aspizu/goboscript/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "dec707a4fac62668458e6c401fe189aec69099901a16bd08a36e246cd488f1a3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bdca032ce9012f761c898d230a03b78072c5282754437a5e458eda422cdb5df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c522493d94f39f9a302d643404cc0d87a1bc1949ded1c850d1bf591a2a0dc142"
    sha256 cellar: :any_skip_relocation, ventura:       "8752ee27a17ac8a51bf27601a165c55069a04386cf7f622968a0a188f77bb361"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e7661902f7efe5bc4057ef055035ebdbd7070d051467f7cfcb7c7151aa21ce6"
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
