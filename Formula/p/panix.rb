class Panix < Formula
  desc "Deploy Nix configurations across machines"
  homepage "https://github.com/mihakrumpestar/panix"
  url "https://github.com/mihakrumpestar/panix/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "c32b471c1a837ccb5789fee895fd724784df0692f5130d8d6e29b18cc4804947"
  license "AGPL-3.0-only"
  head "https://github.com/mihakrumpestar/panix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e9f18fb953475e3fc11f9a14c2c8710390ee0b4628ad7bdaa2488fe2e27bdaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e9f18fb953475e3fc11f9a14c2c8710390ee0b4628ad7bdaa2488fe2e27bdaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e9f18fb953475e3fc11f9a14c2c8710390ee0b4628ad7bdaa2488fe2e27bdaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3212a670f4ba16b890493509725ff1a92bee2b405b329a7cf1a49a95bb6c20f"
    sha256 cellar: :any,                 x86_64_linux:  "d8d2d173930b97ab6f2e571bf74fc7372d3775078ee3b2922c49d473c680b04c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/panix"
    generate_completions_from_executable(bin/"panix", "completion", "--code")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/panix --version")
    output = shell_output("#{bin}/panix schema --output -")
    assert_match "Panix Configuration Schema", output
  end
end
