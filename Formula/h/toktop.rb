class Toktop < Formula
  desc "LLM usage monitor in terminal"
  homepage "https://github.com/htin1/toktop"
  url "https://github.com/htin1/toktop/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "3ce3a9a9737d0d29f10ce1f34a8dfef076ceade49e4ec1202dc7cba955eace66"
  license "MIT"
  head "https://github.com/htin1/toktop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "529ae0f29a5dc523f7803f349abbe81e5b8dbede2c8bcc57dffd467b8ea68b7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13926cffa574f098da9c272a374191659cdf37243e51232f8dd5dbe0952415bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f8b750a28a1c3afa66e4d691861b9511d6220b2457a6cb7c42c9f09901b7baf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c49a9093247b993e452da6a971e2a17755c0fe6352341ce1fd879d49277cb25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c948724cda506733620bc8cc33608b443f79eb38ef645fd136be6c7c4cf7719"
  end

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
