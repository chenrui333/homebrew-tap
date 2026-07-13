class Run < Formula
  desc "Universal multi-language runner and smart REPL written in Rust"
  homepage "https://run.esubalew.et/"
  url "https://github.com/Esubaalew/run/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "fcb22f803107cc7a7a5a3bcafc37e12e150d50ea6b41837577a750779774c1a2"
  license "Apache-2.0"
  head "https://github.com/Esubaalew/run.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "836f560e20190cbcd84bb044eaefb8e43f8887507190b471a73bc6d733382d68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d238535c944cf3eb1d3a2c53e721297e878f6106240a4547b37d736861cfe483"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e8df01e8817110a061ebcbd1f36ac178611b0d07e06c275eac5e2812d7feea1"
    sha256 cellar: :any,                 arm64_linux:   "0580cb7e555f64fb6aeb5c7138a78dd0a22d689cc430ee1dc4e29c970d6e46ac"
    sha256 cellar: :any,                 x86_64_linux:  "49bf164b48a33ff837e30f3959a97a75b17d29907df133d952d9f246c11223f0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/run --version")

    output = shell_output("#{bin}/run -l bash -c 'echo \"Hello, Homebrew!\"'")
    assert_match "Hello, Homebrew!", output
  end
end
