class Run < Formula
  desc "Universal multi-language runner and smart REPL written in Rust"
  homepage "https://run.esubalew.et/"
  url "https://github.com/Esubaalew/run/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "fcb22f803107cc7a7a5a3bcafc37e12e150d50ea6b41837577a750779774c1a2"
  license "Apache-2.0"
  head "https://github.com/Esubaalew/run.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86f1f541fe9acc17b5240af77e5f81d3426c98b381d74a6d33d3b7326906f01d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e24b20382da2dfc458ea81508d0c907eb7cb1a8b8b25d3baad25ba961ff5e166"
    sha256 cellar: :any,                 arm64_linux:   "bcc36305cfd13d2a42a3b0518cec576bbcbde3a3816f5f9ea67589f4b776f4ba"
    sha256 cellar: :any,                 x86_64_linux:  "61aa54d42a7f3b980fa3d9ab0b6dcfb2adfc7980808d09374b28f78d981ba455"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/run --version")

    output = shell_output("#{bin}/run -l bash -c 'echo \"Hello, Homebrew!\"'")
    assert_match "Hello, Homebrew!", output
  end
end
