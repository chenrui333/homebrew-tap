class Kyushu < Formula
  desc "Self-hostable Wasm sandbox for JavaScript workers"
  homepage "https://github.com/peterpeterparker/kyushu"
  url "https://github.com/peterpeterparker/kyushu/archive/refs/tags/cli/v0.2.1.tar.gz"
  sha256 "17d7c5a67a8bf388b03b59768ce8e258bb4ee241a40429d160f7d6dd13b579cb"
  license "MIT"
  head "https://github.com/peterpeterparker/kyushu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5302af16404eaad654ac1336645321c741c05b770f13d307295bf11f3313c240"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "504329c56aca69ecc7cf9d8c804dac82e5648ac970d51a4984291ed67e3aa3fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fdcca48b4241882e0adbc9bf1fe325c6e35bd5018c7a57e4af0f161cf12dcbf"
    sha256 cellar: :any,                 arm64_linux:   "397edfac8cd9aae77cfcdbdd20729cb170c56cdadb285f54bef70cc094a2f9b9"
    sha256 cellar: :any,                 x86_64_linux:  "45ee5a800d1483bad9cc104a9c4354bf69f81a75892dbcedf4c67b2b3a9c47d2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kyu --version")
    output = shell_output("#{bin}/kyu --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
