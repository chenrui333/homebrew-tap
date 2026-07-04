class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "bb2499025066cc60501321ae28bc0cad0aeb90527dd766bd6c9b2b462d612a6c"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc8ecdedd8c918a025992279ee26765432897f8f2d26334c28e677377d536b7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17e7d6ee97965683eddf084b7933702813000373570463337a298e8e85d3cd96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0bdfaf39634483a6a1326a17c39fa1df0a9c92b4a0004ec0315687cf61bbe85"
    sha256 cellar: :any,                 arm64_linux:   "ea89c1a21c2484992e66f742158a562470e2eb0d5e50f4cf878f2125efdeb001"
    sha256 cellar: :any,                 x86_64_linux:  "6f8b3378f2017a616567057ddeae0d60f969d0bff8660dbc03bb1e1d51a1f046"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netwatch --version")

    output = shell_output("#{bin}/netwatch --generate-config")
    assert_match "Config written to", output
  end
end
