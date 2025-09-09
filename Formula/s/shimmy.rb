class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "c74638549ed17b8dd121184c3b05cf89c01760d256d53d1466656b450035aac3"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d542a27b0ba117939f1f1df0278c0a70aef78464a330a83b84faca1b78b70a68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9d8208c7aee2b9938bfa0a26f555ee6ebe295a6e2653704421e6423f2c94cfc"
    sha256 cellar: :any_skip_relocation, ventura:       "648277b570e0cc128f18709ccebb222495780f655cdf2b33ad64da407e98d3c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e912fc3c00805ee2e5c991fe58122c5e19c55b61b9741ac6843d5a33b8fd48a"
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
