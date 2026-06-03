class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.7.11.tar.gz"
  sha256 "6cf4ba1692c841ab9c9876452603b89886b2a49d96da3f43f69f0d2bc7f16a52"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01bc41617d0aaa66056ae0ad4a1f8997e7f9773eb45a5949688ebab295d3b2f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5a758e5711c26698aac10b56442643254203e04fc2189c8dd633facf3585021"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcac2a12b1c95191b8ac81a625adf464f23af537b7a641d3c45294c0307048e4"
    sha256 cellar: :any,                 arm64_linux:   "adcbd4810f2e77c11d9cbd3d6b6cf9a80c7b1c9d06a2b2a1572e56b8a2e4a69f"
    sha256 cellar: :any,                 x86_64_linux:  "14bfd048bb50f763943b130940088dbd718c404c32c313c4104d39054749844d"
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
