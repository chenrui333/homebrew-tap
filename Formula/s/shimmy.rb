class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "c49b3b89b16366a8ff82839d966e9d95c4a4cd8e8ca640b8dda5e39439178e27"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "103d1759fc7ae780522e859612117e41a719cc7d413fc38c5de1a10407fb36e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "970387655d3faa30ace9c94474dd7472908cd92af594a2b8e9d8c8bb54037a6a"
    sha256 cellar: :any_skip_relocation, ventura:       "9f8d24d2d7baf6e74e0e53e75003f720966b4030b210c7cfccc9df4175396f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f7fe9f3746d4b2838bacba037fd309a2e01f5aebb1748735be7fe7a92fd3d9d"
  end

  depends_on "cmake" => :build # for llama-cpp-sys-2
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"shimmy", "serve", "--bind", "127.0.0.1:11435"]
    keep_alive true
    log_path var/"log/shimmy.log"
    error_log_path var/"log/shimmy.error.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shimmy --version")
    output = shell_output("#{bin}/shimmy list")
    assert_match "Total available models: 1", output
  end
end
