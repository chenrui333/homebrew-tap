class Splashboard < Formula
  desc "Customizable terminal splash screen with plugin-based data sources"
  homepage "https://github.com/unhappychoice/splashboard"
  url "https://github.com/unhappychoice/splashboard/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "31062162eddf624449e826141b2f61d1ffeea0fb6cb50384547305010bdcf9c8"
  license "ISC"
  head "https://github.com/unhappychoice/splashboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21d06ea2a400c1db015dc987017d5126a4bbbf194ba1f3a7eb36805a857cf716"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41e9a9cc5c0a95674882f002e8bb746bcdefcc2e1af1ff84a75bee2d816035b8"
    sha256 cellar: :any,                 arm64_linux:   "f0dbc9726f9cd5bbead3174e62f6ee14af3960a3c263693e46737740b7cf3909"
    sha256 cellar: :any,                 x86_64_linux:  "022c327b875e679617410bff7387f60f89b78ed8780560ef9fa319d5382a4531"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splashboard --version 2>&1")
    assert_match "# splashboard", shell_output("#{bin}/splashboard init zsh")
  end
end
