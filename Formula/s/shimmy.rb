class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "850a862a1a9f3f09eca8e654a540672dea1f74ae48374945f31cf7f6297556d5"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f33137c93b6689fb2e12edad8cb97962767a3c9e7f31443312776d5a5b54c072"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91418e5b65104c01dba6292a9a6c30445c196082952896392eb4e76f87eabea9"
    sha256 cellar: :any_skip_relocation, ventura:       "9d8dbf1ff3430fa281b793f24ba485cb102e7f84cd859e1b0e0ebee6fc6a00b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe8542f5360920666ca3d4d7c646e79cafda7094fa20dd046d484f08f709a1dd"
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
