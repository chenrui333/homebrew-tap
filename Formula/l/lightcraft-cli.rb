class LightcraftCli < Formula
  desc "Headless LightCraft photo library and raw developer, with MCP server"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "2d4121bee0dfc5d56479b777ff6e34ee1df8638bc37eaace775b5c258f111f0c"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1291be508a55714637ff00d8adf37f871961ad519ee44dcfdb4b76ca6038160c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81bdb401b12950d6458b0e7f63135da1eae38d28668a7061410ab95c4429a300"
    sha256 cellar: :any,                 arm64_linux:   "e8fbad468f5c07ee03263a8d3e9d5eda5fad147943310ad4dfb84bbe48834f8f"
    sha256 cellar: :any,                 x86_64_linux:  "b2662be9e9659ac98b5b23292747f1802ea24da09fcfcbd21dc1afb0fb07e9ca"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/lightcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lightcraft-cli --version")

    controls = JSON.parse(shell_output("#{bin}/lightcraft-cli controls --json"))
    assert_includes controls.map { |control| control["id"] }, "light.exposure"

    cp test_fixtures("test.jpg"), "in.jpg"
    system bin/"lightcraft-cli", "render", "in.jpg", "-o", "out.png", "--set", "light.exposure=1"
    assert_equal "\x89PNG".b, (testpath/"out.png").binread(4)
  end
end
