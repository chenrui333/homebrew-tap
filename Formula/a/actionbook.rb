class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v0.11.1.tar.gz"
  sha256 "4233230a7fa79c260e29bbc7c6d24d7b82d31d2134662dfcc872fb3e6e4bcc80"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "629311ed1b329732501ffdbe03bf6bd015093210cbde45719f9611f134ffaee0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "196ea32021c23c256434d4809692dd5e6ea6d615a0fc9f13940bb3b532b94cd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc2182d9bcb6bc2a9dd0bcfdb7c357b82dcca34788e45fdf11571e39ca598aec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "638977f841bdb86765b54fba2068bb904fe5f9a532231d4f81496df48cfad1e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "434017e2a083267d9486eaa2a9dd34c2b77daf72989ea4b9f4709a02a2ac1eba"
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
