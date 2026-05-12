class Splashboard < Formula
  desc "Customizable terminal splash screen with plugin-based data sources"
  homepage "https://github.com/unhappychoice/splashboard"
  url "https://github.com/unhappychoice/splashboard/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "56c04aafc934d90c1d066ae6eccd7255d8ea5f69600d576d061b8770fd27bb15"
  license "ISC"
  head "https://github.com/unhappychoice/splashboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d9d1c823cbee413ae9909c6cd2dd6b96002eb0ebaa1953a35554d4e774c5aff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45b62fcc54585eabe86416bd6b996a21e83a86af901b1d11e474e0f6e962f617"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7542769a734e6f6414852059454be30e2c20325e674fae12c5f42babb472eb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55eeec46095f6409ad9e9fc1ab64c0769e3323349d9d35077031f6dd8faa377b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23a485059d318cea288bb743f9825bb207b65c5d31038c79b34fecdbc37dc962"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splashboard --version 2>&1")
  end
end
