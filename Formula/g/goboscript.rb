class Goboscript < Formula
  desc "Scratch compiler"
  homepage "https://aspizu.github.io/goboscript/"
  url "https://github.com/aspizu/goboscript/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "558773962fceb1275875a05d2dab168be790c4fcbe773c8943bb4e9078638895"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f4360a90e27987de5dffa24028e9321a8660af4a01ea272100bb0f2d1bad697"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "775c4fc182f2c5f9458a044ecbfeb32b071dee3b0e7483c18cfe75676bbe47fe"
    sha256 cellar: :any_skip_relocation, ventura:       "5c3b8918bbb96dbd9c053a81bae6475f898d82a9d0767f9c21ad1a24e9a5c286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbf745fc0128099bcc57d52f56dfa0877633fc1eaf6f9e6b157d7d42832c3cbe"
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
