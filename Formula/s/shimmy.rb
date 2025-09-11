class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "1652d06b77dd977e3a3c77b9c69cb3c471262d4565ac3a3c311e62f9b2d8a2d4"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "158efff592f232b2d73be11e1aa4d15e6f4392ac163ecf21e3890deaf26e7781"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cda00fd00250087e801fffeb5eca67bbfe35960fbbfc7118c1ede0ab2b8aa1aa"
    sha256 cellar: :any_skip_relocation, ventura:       "21fa8a7c0b121bd9454801a99714330b8426b1050e3fdda9a1d5501d03441d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60740485ece28d48b02d2218b274123883ffacef280c8449d582fa8c27e96bcf"
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
