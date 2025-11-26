class Toktop < Formula
  desc "LLM usage monitor in terminal"
  homepage "https://github.com/htin1/toktop"
  url "https://github.com/htin1/toktop/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "3ce3a9a9737d0d29f10ce1f34a8dfef076ceade49e4ec1202dc7cba955eace66"
  license "MIT"
  head "https://github.com/htin1/toktop.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Fails in Linux CI with `No such device or address` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    ENV["OPENAI_ADMIN_KEY"] = "test"
    ENV["ANTHROPIC_ADMIN_KEY"] = "test"
    assert_match "OpenAI", pipe_output("#{bin}/toktop 2>&1", "\e")
  end
end
