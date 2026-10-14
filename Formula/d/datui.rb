class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "220efe3f0048f11173126536e8f3ba1917bc7592e5a7358ddae3b9cebc8e2424"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1eab4d69e347e8f099d001441f9103079260df9a61883391609f83d70e456e09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a474e648233ca1db3a7f93f6642393cabdf6871ca4d6c2612a10d994bd234589"
    sha256 cellar: :any,                 arm64_linux:   "f12a228fe7b8ba3f6bbf17f91cc3b8f0419fce24f07ab1617ff0f0279dee1caa"
    sha256 cellar: :any,                 x86_64_linux:  "c7bff66909983fb58b4d7957110d94123f1daeb17b5b44c50c2480348e9e025f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "datui", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/datui --version")

    output = shell_output("HOME=#{testpath} #{bin}/datui config init")
    assert_match(/Wrote .*config\.toml/, output)
  end
end
