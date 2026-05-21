class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "20d816978b9e43914e54310a7e04fb35d0c2990c3fdc4313947e159ca18b239e"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "791b78d04198902cef1f6498cbb7351747d9d80baf808a844dc3ff92a1440d21"
    sha256                               arm64_sequoia: "ba3fd04860d70f42494c98674029246691b32d566712ac8a6f1fe5174c8aae71"
    sha256                               arm64_sonoma:  "7f1343bf3a73cc7a5c8ebdcf8fe7b40398bfc587b8f5add7b40716f5c9a8ea66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1cc4af1cec78f603ce64fc3a47d4a8e0ca19c22981ec380daef0e7c234d56e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46efa5c04d934e8834fd9e6e72e01be9742d285cbd4e58f7a6201294184a7062"
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
