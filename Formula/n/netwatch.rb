class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "9f1504998c9ac6951a9e75a7f7265c90d15fe033aca00952ac67b17873e893a3"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd6fb020b28f938e6ab630200c970cb0e4c4281e9a61278818016bb803b714f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00a58af796bebe18b66b7ad1edd49cda65bcc7475cc862b2d648e7c72e451543"
    sha256 cellar: :any,                 arm64_linux:   "163a5d69b0c9987b6adf0ebb9c6b360b1c83b418444cb8f35f8c1719218aa989"
    sha256 cellar: :any,                 x86_64_linux:  "1ce5765a9215188ee19942091b5fae0f25136b5cbed3f7537aef7180bd09b8d3"
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
