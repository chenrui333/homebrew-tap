class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.4.15.tar.gz"
  sha256 "5e0706da6cfcff04822cad1b8b6335ad8105975be9246565695763d76f4633f7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba5309155286881b2a05dcd526e90995019ba4f2182461a7510b14e3755918e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e75297ebfaba809ff6fff16883d54b81416ca065ef93ffde1fa066cdd86131f7"
    sha256 cellar: :any,                 arm64_linux:   "d6706e77fb9ec9ffbdaa0ccd3d97c96e27f3d5a16753b2d40e57fe25c2df31e1"
    sha256 cellar: :any,                 x86_64_linux:  "0e78db4a6b5f8bc91f77075ecef52fb1b0ba7669f8b49828af05791a4ea8856f"
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
