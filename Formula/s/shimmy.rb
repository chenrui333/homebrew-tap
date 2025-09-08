class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f81c3d392edd60579f677f2963407885fe2f710ce9aafc0a0977f1e45b8a60da"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "461d0dd780841c418236c71124bb210f9942defbcfee1eac2edc8fe9fbb3ee15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "648538523db789ed1fdd9a2646be53683dc9cb7093a073d490fc1f286e2e8ed0"
    sha256 cellar: :any_skip_relocation, ventura:       "e613c7ae6f99376e98303ac6a6c03574a11a146762e37a329cf778be38acce7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71bf9ab0659a0e7ec647e5962782c2ecf2016dcb362c687c928961fe4fa09cff"
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
