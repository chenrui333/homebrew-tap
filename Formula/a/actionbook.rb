class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v0.9.1.tar.gz"
  sha256 "4b2c93a4c1fa763b616fe45a268811ebebfa1816ca1e759b96e54af3087ff7fc"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c8a89ee33d1d135102d0da7900d9fa4ec521ecc53a281e92cf3cd6bfebd7050"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edb6b7c24def7057cb60e9e187d9d9289f8b08e48bdd8271d48fa3d03c8ba756"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70da29224036320f1e05e2248c35a782528910c6e2a9af022b9335f93ffa4a6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ce2b2345744bb4b9d324def64722bcead9281368f5f34681592d7ac3bc7f136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2ca392c13eb1cd5104b07bdc9d8c077f01e02d73fd81e24878e4eef568c734a"
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
