class Rusticon < Formula
  desc "Mouse driven SVG favicon editor for your terminal"
  homepage "https://github.com/ronilan/rusticon"
  url "https://github.com/ronilan/rusticon/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "60fb18dd973c87a123a7e41d3ba8415910333900a4f86a69c058ed6b53f76908"
  license "CC-BY-NC-ND-4.0"
  head "https://github.com/ronilan/rusticon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96ecfbfefa7512cca1a3ee7e00a147af334aa835cef4fa1b4d793c1bd124579e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab0f8e4146dfdea6794690454f806f6a0137f629ca9f06f3011b0d09bd750dfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22fad6216399eaa5e34603a8261f988da0acd38d99477d467823d027ebe9025b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e271e262bd34c0e837d08218eabc054a47463d515f79400213c7bff885de874b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95b78aebb06ce385c74d5e33c29003acbfff777548b9fa498c12c86f02ede1c6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Fails in Linux CI with `No such device or address` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"rusticon", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "An icon editor for the terminal", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
