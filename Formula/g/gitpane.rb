class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "1d0f42502888c6cef7edfaa34e12b84a795d6abcbb94bd7192247d2ed8cfd8b4"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "cab934f8fbd48a72393cdbc9393aff911a328a1494438d855de293f0ca9b7533"
    sha256               arm64_sequoia: "db49e23441e1da36e812278aadfbf6092404a520397d3d2d79f8eff230f95f39"
    sha256               arm64_sonoma:  "7ebdbf2238f074b35e2a4f06c1e5d490ed09ae020a15ba7674e0733cca78a732"
    sha256 cellar: :any, arm64_linux:   "ec152bfff622d6e93f0df258ce71f674358f3b7e85f5502282491bd56477f03e"
    sha256 cellar: :any, x86_64_linux:  "f9e718a2339ed2b2861b58851f6e118b75b558fcef0a781de8c68396da69ef10"
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
