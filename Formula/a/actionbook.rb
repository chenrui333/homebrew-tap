class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v0.8.2.tar.gz"
  sha256 "6e180fe92854c9ac7b46a6d42b0bedc83f155466ecc8b428139dcb037d53e2d0"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f6a61571911ac0557af1c8ad1da9bc8f51027dada7a5d744f642fc8c98a4855"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caaf95616e76f9c068a2fa8e84721f44ee8cb963107f076ea5aa99b7195a4e41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17c8db2908f1df78d74ee9ce0e8a6c19b57d6d4e90afeffe3834705fb8eeebec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4743854814cd6bf96bd360a905f22c0814ae88c15be6d94fa62f8330f13921ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "416146f1fbba9658a9f32711fc8f4c82a4ba04b3102776250fe7752a4e1a2b92"
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
