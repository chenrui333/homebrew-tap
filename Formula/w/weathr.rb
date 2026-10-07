class Weathr < Formula
  desc "Terminal weather app with ASCII animation"
  homepage "https://github.com/Veirt/weathr"
  url "https://github.com/Veirt/weathr/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "aa940326f41b23db192165f831567656ea50eb73c971519cbc83adc6d3a21908"
  license "GPL-3.0-or-later"
  head "https://github.com/Veirt/weathr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7999a2bd850b4cc4913fa0b7058b46bad2e0fbc90d621730048e656394b48de8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5b647e60cf5c6245415701677dcd1f7a3f18e91894fda84c66a0c7f2d177d9e"
    sha256 cellar: :any,                 arm64_linux:   "e90e7da6250aa5e34521a11d0c4a75018ec191df1c683b0ca8d1a4499ee98f87"
    sha256 cellar: :any,                 x86_64_linux:  "67534b5502a05959a56fac617b1ef994158a13ddacf5e1cde61937b7747cac07"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"weathr", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/weathr --version")
    output = shell_output("#{bin}/weathr --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
