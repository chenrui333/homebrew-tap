class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v0.11.7.tar.gz"
  sha256 "eeed2f46041598067251c9542c8ac11e20a17530e53f33e162d7fc9ee731bd04"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81b3f48d1a4ad2116e41dbf999785941be0871a10cde6bddbe0779b6990ec877"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84a78ed3e665e102d8ba9ebaf15c673ad19c9e41ac28ebcc2cd800c2e9a47891"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7346f8b96472ea1da4bf7d10e22c0406e3fe5695e534f894f8174595437cf7ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c4cfe0ed41571a153e964ca6072e0a44bb8d042dd03cd37a7a3c2889c676ff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0466eec650178858b63abb1ba60a4da9be454f13af4eb7157bc220f780756cf"
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
