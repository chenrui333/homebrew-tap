class Run < Formula
  desc "Universal multi-language runner and smart REPL written in Rust"
  homepage "https://run.esubalew.et/"
  url "https://github.com/Esubaalew/run/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "c4b0e68e60e8ffe643830bf3e1c6abc735d0cc5fe6ca37263eca47c6e4d0dd66"
  license "Apache-2.0"
  head "https://github.com/Esubaalew/run.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/run --version")

    output = shell_output("#{bin}/run -l python -c 'print(\"Hello, Homebrew!\")'")
    assert_match "Hello, Homebrew!", output
  end
end
