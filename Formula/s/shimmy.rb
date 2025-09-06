class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "37474ddd51dc4a7e6a09189f009a4ebd8a415c807809803abcf637474c5c7bde"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bfb03f5fcb21e2629f75388623c3b605afff449122258c0645b7dadf8e79b0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbb4625d1ca16510539ebe88d9c60e94f2b47a0ef9bfe412750b3bd1a876a858"
    sha256 cellar: :any_skip_relocation, ventura:       "baa5c2f099a80265d0f9927e74e17de5d53750bb50d2fd91877a24af1e3a27f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb7654e08fff76d88fad3047342c949b7db5cf85d910ac1247ff25bd63ff5025"
  end

  depends_on "rust" => :build

  def install
    # patch version
    inreplace "Cargo.toml", "0.1.0", version.to_s
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
