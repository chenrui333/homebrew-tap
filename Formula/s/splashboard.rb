class Splashboard < Formula
  desc "Customizable terminal splash screen with plugin-based data sources"
  homepage "https://github.com/unhappychoice/splashboard"
  url "https://github.com/unhappychoice/splashboard/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "31062162eddf624449e826141b2f61d1ffeea0fb6cb50384547305010bdcf9c8"
  license "ISC"
  head "https://github.com/unhappychoice/splashboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8e570f7cbbce2904b79042a78b4ec9e5390f4f713b7d0897fb5005ea324d149"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93ac0284ddd7237e01867397f26fafb2fc3f81973ee8dedf3d3ceb90955f1905"
    sha256 cellar: :any,                 arm64_linux:   "834bd9404fd9a7237e63f166afe5d9549286e79ed865ec4b04c3b764ffdfc241"
    sha256 cellar: :any,                 x86_64_linux:  "99cc7a6b4f8906c78d6a050a165d4749a28586244c4d5c437c2372c84bad8775"
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
