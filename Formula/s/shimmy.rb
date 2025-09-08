class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f81c3d392edd60579f677f2963407885fe2f710ce9aafc0a0977f1e45b8a60da"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "227ff855d41aa6d7802f8a00599c14ad333d6d4c81cdc2a97460b03970bc6a52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3daf0bca4f6494e39770e4a836becd2e0e1efa51f202bd3ca7ebed22647e18b"
    sha256 cellar: :any_skip_relocation, ventura:       "15ed6ac233ed29c81dbf1fa0bf3b85c79d0b97532997f6361413fd7db0adb36e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fbd5bbb60555cb4901d47f34f81d3aaae21343c7f2dd3c30087a71cc267d083"
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
