class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v0.8.4.tar.gz"
  sha256 "eeec8b7ed962d6e69b8e8c17d077b846394493daee1fd1fd67ef3337ed68818e"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49420168634b8c429fd105ba8549a12581f59d8e8f38c673de71c0958b0060cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ccdb92503253bb860bed8df3e496e75bc47a99a0bc45a457a5b7451c1e71ea1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9973e261d51aa6a47d5a6572733b4665483be57427de91037958b84505a6d73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf9c1fe979ad3c7f8f56a1252fdc46c0feb0e338720ced3fe817a5315f437539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa0a532e1cee8d58e2b5dbe83f9d7870d989a2fa6e6e9bf7d2ce879eceea5c6d"
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
