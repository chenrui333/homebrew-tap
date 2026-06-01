class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "fe589916752d967be3fa38da38c72941132f2ad9525037a1244563b1b035ec8d"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d78986139822ba3a659df140703231d94fb1b2e681e56a790c653cedbcfedf46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb4695b869e633c2ff7a32c76788fe0a11bd04eaae2f916f20232d667b88f05d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08e06a34c57457b8b2618c906121f3531c4030ca9e714d26a2af7992f2bd86c7"
    sha256 cellar: :any,                 arm64_linux:   "b82492072ec05d9efff72aa2633fa7f0bc8480bcc1f7fb3c977dff46187d3e6d"
    sha256 cellar: :any,                 x86_64_linux:  "38aea570952f04c72c6d19f468e590612efc06b4c0f4f0e7bc080f82440ac803"
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
