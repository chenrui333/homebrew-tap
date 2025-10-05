class Run < Formula
  desc "Universal multi-language runner and smart REPL written in Rust"
  homepage "https://run.esubalew.et/"
  url "https://github.com/Esubaalew/run/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "c4b0e68e60e8ffe643830bf3e1c6abc735d0cc5fe6ca37263eca47c6e4d0dd66"
  license "Apache-2.0"
  head "https://github.com/Esubaalew/run.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c09101cd9545d6d33cf04e7f62bbc4b9fb200a9f0c45736bc1fdb241bb4db790"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15d4a044f9189b03239f02e2bd697038c854d564eb709f39fc143f577e0e6e78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac95a034bc8dae0d26bc9db3e2c2ea45de4e7f8f5af069241577e7c4b20211af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73767818c17903ba7e225e3db5a1f37a6f2f76e37e0d7fbcd3fdb656a8b9b380"
  end

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
