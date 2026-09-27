class Reeve < Formula
  desc "Local web development stack manager"
  homepage "https://github.com/yetidevworks/reeve"
  url "https://github.com/yetidevworks/reeve/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "0e217718bdb3d7a1dfeb5a3e5ba3d2d7636cba03485d1b78c8173fe285a8cd28"
  license "MIT"
  head "https://github.com/yetidevworks/reeve.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06d321d5714833d201877801c7e883dccbf810b1226bf279035b424a9d099589"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ec947bd917e4b8deea687b0aa855ae94e373019b224961ec2859655adeb0fbc"
    sha256 cellar: :any,                 arm64_linux:   "571fbf15b01903b879c70042fde8cadfee61b809963444f46a996ec47b7ee793"
    sha256 cellar: :any,                 x86_64_linux:  "2b974c959d9b28d2dd165b0053e7cc2d28243abd8584b950ccd2f9cf8df4f417"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/reeve")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reeve --version")
    assert_match "No PHP versions installed", shell_output("#{bin}/reeve php list")
  end
end
