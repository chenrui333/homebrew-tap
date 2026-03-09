class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v0.9.0.tar.gz"
  sha256 "9e8c656c8951d7e3d1fc56e6a2366661719bd30ef95de4e8a3c43a9a2b7f70ca"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0767a8df685b7db40e94da882fb701b1182e421425cddcb091ff7c1fc78cd522"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bff2fdd9ab64889ab1db7b4da4b753bef57261c339504800dfe43e1e9a407007"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00b72ef51dbe4ad8aaa4ea888ecb1c8c21414fabc574e0bc927cd4d5f31de27e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12dd3f23f63bb43892ae8077895f8312feb4de4674a7786ec4810414094c222e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d50620151578e3195bd71886adc4f9663cde0fd9b0099353d719e097956313ef"
  end

  depends_on "rust" => :build

  def install
    cd "packages/actionbook-rs" do
      # Keep binary `--version` aligned with the tagged CLI release.
      inreplace "Cargo.toml", /^version = ".*"$/, "version = \"#{version}\""
      system "cargo", "install", "--bin", "actionbook", *std_cargo_args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/actionbook --version")

    output = shell_output("HOME=#{testpath} #{bin}/actionbook profile list --json")
    assert_match "\"name\": \"actionbook\"", output
  end
end
