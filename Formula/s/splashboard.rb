class Splashboard < Formula
  desc "Customizable terminal splash screen with plugin-based data sources"
  homepage "https://github.com/unhappychoice/splashboard"
  url "https://github.com/unhappychoice/splashboard/archive/refs/tags/v2.10.4.tar.gz"
  sha256 "20f62e95ab57b0f07cf6778ce915a0ca081d859763db43f3344ab07333b5f225"
  license "ISC"
  head "https://github.com/unhappychoice/splashboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86c7bc8023138e7dbebefb10a59a51d6ca03dfbbe28c54ce4fa6d26e85128c04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2333b56bbfc688ed3847bb646fb45f85f2d1f5e0e5650f674769f7a864300c5d"
    sha256 cellar: :any,                 arm64_linux:   "de624689f9b8fed3cd76fd3affd006f91a654dedd7b577bf2ac627e1ddd56fa8"
    sha256 cellar: :any,                 x86_64_linux:  "7775cfa4afc996e1a01ae0dc050a15339d7c1ee0b92a72082f214cc54322c259"
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
