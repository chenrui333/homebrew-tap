class Yeetfile < Formula
  desc "Encrypted file sharing and vault service for web and CLI"
  homepage "https://yeetfile.com/"
  url "https://github.com/benbusby/yeetfile/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ab581b920bd7f52f00c5baed497f51cdaf5608c32340949587ee0769a6fa81ca"
  license "AGPL-3.0-only"
  head "https://github.com/benbusby/yeetfile.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33e73e7b728b82248161320fda5f0d6e32baf0ac56a99ef4a84afa353f5c5d31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9af6e328b9cf755aa89f54209c272b021ee639679858c4ab247943bf48b0625a"
    sha256 cellar: :any_skip_relocation, ventura:       "af1beb1690286a1058a83c88aa92d243e27ccf42c927cfcd6a3c123e4096b13d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6af7ccab75219a6fe6e1874d0412186462789afe9ddf26084678bc10a6db0a34"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli"
  end

  test do
    output = shell_output("#{bin}/yeetfile account")
    assert_match "You are not logged in. Use the 'login' or 'signup' commands to continue.", output
  end
end
