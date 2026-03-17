class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v0.10.0.tar.gz"
  sha256 "b72731c25d1782c18330667360a6362930f47d357269e5d99e49d6358e22ed7b"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99956989a7e3540bf6088bb38ae303fc3198e044b22099705b3f5738bc4b8def"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a34dafb63ef4979d6a198c36d74fd8d97f460f387e74f36adf5134a9668bac1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2c0021d96f0b181b9bff646b234ce988a7a0292db9803ef8d9e955bf3fb9cf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca65952de75c1a302e403ffaba1a9deb09e841c10ca7a6f7f3e343b49d736613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5299a1930fdf7dd5c6739848684a7d77536e11e94ad240fe60c788cb46f91b5c"
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
