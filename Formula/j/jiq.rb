class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.31.2.tar.gz"
  sha256 "0efd9a326e9dd76d3ed67d6e0acd78767ad704cd850b496baab845dcb426d407"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "deb5363d11cb806317975b4f00fb3308297afce39a2b7904af5a39a38ac71217"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5cc56d086c26df90cb2e639861195a9cf564333e956c040c5c2b038e193d1e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a849978eb933789ebe7691e194dcf6b70dbe4af00b2fb46fcf12bcba0141d207"
    sha256 cellar: :any,                 arm64_linux:   "d9f639593c2ed3f521ed4020c11ef9baa746f2d7be33d2d64e359d5f71ddc468"
    sha256 cellar: :any,                 x86_64_linux:  "cfddbfd93d3eb159f14779cd0c2aea861ec65494dbb42eff924e8a4b922d680d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiq --version")

    (testpath/"data.json").write("{}\n")
    empty_path = testpath/"empty"
    empty_path.mkpath
    output = shell_output("PATH=#{empty_path} #{bin}/jiq #{testpath}/data.json 2>&1", 1)
    assert_match "jq binary not found in PATH.", output
  end
end
