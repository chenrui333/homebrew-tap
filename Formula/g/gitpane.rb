class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.7.12.tar.gz"
  sha256 "ce0a2a134591642bf0c1e014594d06071bc0f90e0981a8b63525174db418546c"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99203b46a9eb576c5e28722cb9f862abd076d21b1bb1faa3787fb97a850a35b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87f05f4f57596d310a9af0e808b38628766c55e626f629e506e682dfb931ae46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3932fdf576b6214a42ca87c59cf42b74ba9cf042c6cbcfe05afd982de9ec42af"
    sha256 cellar: :any,                 arm64_linux:   "a42523d8f4914cb4b7a9fbecbdc96b0d901d37a8dc54addd72b6bf3b0a381dd9"
    sha256 cellar: :any,                 x86_64_linux:  "0117781f5e457f6b2158d9d994be3022ea5e3c31139a6e472d01a38212db78da"
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
