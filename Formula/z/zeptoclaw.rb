class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "9df5ce34bee506b2968af7b8d257a4574d72dc8f8978c72756f7e61954fc120a"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a039ddee676df50fab485cb68748ac9a5d69805f7df6e07b3982e12c728638a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46c2e7e46d76ffd1c5dffa9271670a20cdafa8cc2daf4bce34821db22063c953"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80a0ab58aec3fc61b20a6193cbb90da8b2f32de7128fa41f0f2af46bba7c7595"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a283c47d3086ab3605c26757a64f502bcbe9688bed6877e1eb35e72d6bf99a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b350f22c4e4c97e296000f44a886c75c2edf39e6fa37d0263a80779fc5c7affa"
  end

  depends_on "rust" => :build

  def install
    # upstream bug report on the build target issue, https://github.com/qhkm/zeptoclaw/issues/119
    system "cargo", "install", "--bin", "zeptoclaw", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end
