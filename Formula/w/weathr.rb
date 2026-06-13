class Weathr < Formula
  desc "Terminal weather app with ASCII animation"
  homepage "https://github.com/Veirt/weathr"
  url "https://github.com/Veirt/weathr/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "aa940326f41b23db192165f831567656ea50eb73c971519cbc83adc6d3a21908"
  license "GPL-3.0-or-later"
  head "https://github.com/Veirt/weathr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "562af4933ca4cdf5b2f05473c9418d88d35236511e888e1ff72bd26bb0357f3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1c7b1f3545c23b8110eaa69be2ea516d0ae01a42fb27cc03bb500eaec5bfb3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f5dfb3c991f9a085e857016d0a19d72ef884f8c62e0482b9818bac542798c0d"
    sha256 cellar: :any,                 arm64_linux:   "004158404ee072bc9a3429146acffb7cc123feac5acf2bf3c80a4b0e5e51b2c9"
    sha256 cellar: :any,                 x86_64_linux:  "b774b8bd2cca20f8d226ee8a41c127f2baf261d600eabe9cf812716d2bde9596"
  end

  depends_on "rust" => :build

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
