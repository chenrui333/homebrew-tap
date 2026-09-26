class Splashboard < Formula
  desc "Customizable terminal splash screen with plugin-based data sources"
  homepage "https://github.com/unhappychoice/splashboard"
  url "https://github.com/unhappychoice/splashboard/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "9fe2ecbd1f5d4cc953e0cbe2bca755905aa6e05865b6150c6cfbebbdcb331506"
  license "ISC"
  head "https://github.com/unhappychoice/splashboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da4da28f260ceb7d0a2c74a052ed1428c22e091c8dd16a078170c5ee32997630"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eb98c3e5987fb3fa0ef2a741f75ce2f4fcbe1f93c495535d654da5876b3f6f7"
    sha256 cellar: :any,                 arm64_linux:   "917f2888b43da720ec2a23ad5d2b1d9598cb51b57efd2adb99115c93b1ed2179"
    sha256 cellar: :any,                 x86_64_linux:  "b7f51d64183562149c9842fa05706072b505a053ccd63c1712b6385d336cd336"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splashboard --version 2>&1")
    assert_match "# splashboard", shell_output("#{bin}/splashboard init zsh")
  end
end
