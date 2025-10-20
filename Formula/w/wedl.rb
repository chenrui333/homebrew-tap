class Wedl < Formula
  desc "CLI to download from https://wetransfer.com"
  homepage "https://github.com/gnojus/wedl"
  url "https://github.com/gnojus/wedl/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "1d52adf91a6a0424e54610741b48384135ee2e7c4c2bf13e8a9f6f4d301dd1dc"
  license "Unlicense"
  revision 1
  head "https://github.com/gnojus/wedl.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faf695f102a353566e90e1fe6fe936c56ffc5e6fb9a3911f4c0d3b8dfc99eb92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faf695f102a353566e90e1fe6fe936c56ffc5e6fb9a3911f4c0d3b8dfc99eb92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faf695f102a353566e90e1fe6fe936c56ffc5e6fb9a3911f4c0d3b8dfc99eb92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f01930c64cca4b3bf00345d1db91a11f25bd32476312f8783a3be4bf8f92193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7635658180f05f32cf94e595657518dcefff4da1d2593c7ad490c6f76ff6f07"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wedl --version")
    # system bin/"wedl", "https://we.tl/responsibility"
    # assert_path_exists testpath/"WeTransfer_Responsible_Business_Report_2020.pdf"
  end
end
