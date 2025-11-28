class Lazycelery < Formula
  desc "High-performance TUI for Docker container management"
  homepage "https://github.com/fguedes90/lazycelery"
  url "https://github.com/Fguedes90/lazycelery/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "9cd598627727535f63c5c5184c28779ba6bef9f917592a1fede2b23f4a19e53a"
  license "MIT"
  head "https://github.com/Fguedes90/lazycelery.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd2015f625d5ab57ad25b8b9c4bb48b3a138198f0b18aecad985e8806d1b251e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf23f9e4ad89e26c8940aa07a6a4cfd2ec673af4eaab4dabe4d7b8e9e281956a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f8c7d221d96c23be9be166a5f5ea2b0da6e6632e32865acf01bdaf91631f6dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c465e4f360ab6b6e98b97bbffa5f12dcef818bd7087f012a7ef0fc31e2f2866d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddb43529c3c76e74198374310649995f39fa0eda0ed48783b7eeec9d41a5784e"
  end

  depends_on "rust" => :build

  def install
    inreplace "Cargo.toml", "0.7.2", version.to_s
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazycelery --version")
    assert_match "No configuration found.", shell_output("#{bin}/lazycelery config 2>&1")
  end
end
