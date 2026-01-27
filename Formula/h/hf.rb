# framework: clap
class Hf < Formula
  desc "Cross-platform hidden file library and utility"
  homepage "https://sorairolake.github.io/hf/book/index.html"
  url "https://github.com/sorairolake/hf/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "a7bf875dedd673fba5bd69418ca197eeaa7c8772ee57601bbbc01bd9e0d3bad1"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ccacca550ba952dd1890e00527450aef922583e3b8510eee86ce4efc4deb3ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2411533e74e66057fbb2ef1ca62b1f8f89572f17eaa4146620d37b1140fd899"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e281514c1dd7f109ab3ef599a7fe1c2d4d4e22f2ef9e3d64b3db278229f5a1ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d10f360622cc692fe8e2f63f562aa2e441752fcff855cdd4f7e3a5b6cde2f3cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ebcdc4542532fba9e88939ddc74ff19681752f0956b1382a03d5ec523334758"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hf --version")

    (testpath/"testfile.txt").write "test"

    output = shell_output("#{bin}/hf hide -f testfile.txt")
    assert_match "[INFO] testfile.txt has been hidden", output
    assert_path_exists testpath/".testfile.txt"

    output = shell_output("#{bin}/hf show -f .testfile.txt")
    assert_match "[INFO] .testfile.txt has been shown", output
    assert_path_exists testpath/"testfile.txt"
  end
end
