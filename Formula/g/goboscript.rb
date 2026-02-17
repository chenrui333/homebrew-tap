class Goboscript < Formula
  desc "Scratch compiler"
  homepage "https://aspizu.github.io/goboscript/"
  url "https://github.com/aspizu/goboscript/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "6c8de14efeabf33d64db7b17d81718b585a221a09db2422b72eb82eeed817664"
  license "MIT"
  head "https://github.com/aspizu/goboscript.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dc7f921bb5be854c3fbc455785803fecfedd55236659ef00f860c5a7bc4213d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "280eb6096af810dee9d45a03d8e5c55ea5c20cce692dd3b76a2abc0ed95624e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fe0c8cdf3d9168d299c498ac4b00ccb9d27efa0985945a8a1a5b1a29356f3f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be72f2e49a7d7f6dd208a7dd0dbf3e9918e83b18fb4fcf1b298c44723167c91c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7036e83dff6e832d0f4f697b6af0acaa4721e3bddf8c7237c00296f3c3eca1c9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    [
      bash_completion/"goboscript",
      fish_completion/"goboscript.fish",
      zsh_completion/"_goboscript",
    ].each do |completion_file|
      rm completion_file if completion_file.exist?
    end
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
