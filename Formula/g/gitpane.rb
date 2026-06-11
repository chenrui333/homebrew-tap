class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.7.13.tar.gz"
  sha256 "7e5baf4473e2bbe5c8dc29a4a4ad6bf8b9764ba5582affeda5a3de8257d992a6"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a170d6cf6c56cc86fd4176d54349ac12279de83e0c918bc871053eaedb161521"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62f31b7d3eca4676dac4e7a6310fc34696b2f5cbcaa6cf1bd79982ff24129658"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e3ff59cd0183e144d132695446dba6073fd15c6d8417123054468257af41add"
    sha256 cellar: :any,                 arm64_linux:   "3f4c1754a0f3dde97b6171678f76008632b73ddaa955a3550974b2c51210d85d"
    sha256 cellar: :any,                 x86_64_linux:  "d979521ebf38ae3d2d5a965822d7a6ce3a2e781f414146fe326bfc42fde389b0"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "gitpane", shell_output("#{bin}/gitpane --help 2>&1")
  end
end
