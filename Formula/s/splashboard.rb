class Splashboard < Formula
  desc "Customizable terminal splash screen with plugin-based data sources"
  homepage "https://github.com/unhappychoice/splashboard"
  url "https://github.com/unhappychoice/splashboard/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "56c04aafc934d90c1d066ae6eccd7255d8ea5f69600d576d061b8770fd27bb15"
  license "ISC"
  head "https://github.com/unhappychoice/splashboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4ceefc060a5f455307310f6d239753f80e384be3e4f68af98835c1f8bc0b003"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de5446a3fc2ce98cda8109ec9cac387435672409c8798aa6ecbec4f66ca36105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82628e4e810c18dca711dc7722437e81adee3ee6403246a657e1a831b23e34b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf69890e73656987b659e2f42f39d454a575cc494cb8c25783f75540b481d955"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "440112d16e73f1840746744c6bfd4aeaa80b80aa9f95d6ff3b3454daa0354cec"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splashboard --version 2>&1")
  end
end
