class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v0.7.5.tar.gz"
  sha256 "dd5c9bbf9794226b9a18ed963838312c01d4c7e2cdeb7cd1421aa0f443fcb171"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f1904a45f795a1fe92f95d97ab6d56f419a24263dcdbbc6d99e184d7d0efb5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd1f6a8ce5eb84654933ef9fcaf357b0566f983629ff02da7fc4675879713030"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b5ac25557527e99c414a3af9ac0bab095bbeb34ba6c574780777db762e95388"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26523c02788cb036094ab935def8d97376194197a225d910be9981601fab0c62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1ce253735b410cb5fe4e8b2fbbb093a53eb1f852f4c8f3dc27038f2fe6bcb36"
  end

  depends_on "rust" => :build

  def install
    cd "packages/actionbook-rs" do
      # Keep binary `--version` aligned with the tagged CLI release.
      inreplace "Cargo.toml", 'version = "0.7.1"', "version = \"#{version}\""
      system "cargo", "install", "--bin", "actionbook", *std_cargo_args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/actionbook --version")

    output = shell_output("HOME=#{testpath} #{bin}/actionbook profile list --json")
    assert_match "\"name\": \"actionbook\"", output
  end
end
