class Darya < Formula
  desc "Disk usage explorer with a TUI and live treemap"
  homepage "https://github.com/mrkatebzadeh/darya"
  url "https://github.com/mrkatebzadeh/darya/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "c119350a4943ee1663a680046bba06fac9c0c6971fd61e93182ab3c366dca3ab"
  license "GPL-3.0-only"
  head "https://github.com/mrkatebzadeh/darya.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72621f1dc10f899d05f8a19be457300d992122475c9f87b6735813d145fc27cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01b2391f8e07ac6b13fcf82951d859c0ccfb84ebcc71b0cba23a81f486046e1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24368a249c5f76f1593b1614091a48dea7a379497e696da3826ef437ba1d16bf"
    sha256 cellar: :any,                 arm64_linux:   "102540e7dea8723da17b0e55b12f9ac834a29279fae117dfd50d6d165c1e2433"
    sha256 cellar: :any,                 x86_64_linux:  "4084a1665e5281722dd3e5a61c238cb45c7fa370beea8b506aed2e438f58372e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/darya --version")
  end
end
