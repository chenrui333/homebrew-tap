class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "eec202a03a1a7d2910e6df5bc33da60c3627cd3668d7f153b0dbcec4aa209698"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fdb8b916f0dc20971d48de2f70c42215424ff35c071a3452f6653a159ca3d8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c350efde66fbb38afa643aa7333e1bf60c125c353f6ff2c36b127f5eb7d53f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71a516a6806d5c4d6e291807fb7e2cf959cfae8480e238924de37eb2adf8f189"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "172d0d864a137a9e3e7728d59c2cc2acf1dc78aefa88ef7b9c55d19f2e663c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47f4d54542c51c373b27f76ecb253b542fb2097c25ec964ea088c648f3978ad8"
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
