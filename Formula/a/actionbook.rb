class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v0.8.4.tar.gz"
  sha256 "eeec8b7ed962d6e69b8e8c17d077b846394493daee1fd1fd67ef3337ed68818e"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7dba38bd8d78feda06cc52bfc2f2e90492f07d8befd25185466e18005fbdc92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "459b4b969b575d51706ff06134c0be253f7915308f4a80b541e4b7bb9472674f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e34e572d486bc9f7b835363c90b7166df28993f4397cc5caee5f75676fac534f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9380876415fce5a360c4cfc89279101a479f4cb15c0ae61cd9564b68abc5eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "322a8b4232a0b07bbf5d9bf710378c9f403f3da2c0962a89cbe89beb3423ccfb"
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
