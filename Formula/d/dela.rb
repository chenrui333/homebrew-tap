class Dela < Formula
  desc "Task runner"
  homepage "https://github.com/aleyan/dela"
  url "https://static.crates.io/crates/dela/dela-0.0.6.crate"
  sha256 "8bacccfd80a9d65db3c1209cf1cbb391ec1c02952416a05ca8c62536553912f1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "788ca5bd34ae95d10af54485fb355ca656c9f864c44d74042455f9ae6c5ee503"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a73beb8b3f0690cf231b91a4f7273606dc334371b5d83ac142ff782e664609a"
    sha256 cellar: :any_skip_relocation, ventura:       "d92f01fc90f960fe4b9a959429c465e520a777848f63b5f7e8bd3d565210c908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07bd6b77a823f16a41b8e0dd8a5d53d5b6c19b29a15475fc441f767dcfd0f8f2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dela --version")

    (testpath/"Makefile").write <<~EOS
      all:
      \t@echo "Hello, World!"
    EOS

    assert_equal <<~EOS.strip, shell_output("#{bin}/dela list").strip
      make — Makefile
        all                   - Hello, World!
    EOS
  end
end
