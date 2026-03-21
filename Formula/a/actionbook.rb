class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v0.11.4.tar.gz"
  sha256 "527141229af75a4310cee076f08a9a22d837fc0091c4a48860b5c6a349e42f63"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c73fe90c122cb42d2449051bc311ffe475a0b40ba083badc0b3a4a4cb98dec2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32c74288e4d9979e6861e7ff28b3490e4450267677948a43fa1e4dd746f9e1a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d741ebf703d9361ff246e9788b2182189593abff64385d090910bdf47a18d6fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d234f2fef22dbe316d878fe4dcc9537d2e7d73d1b2112216e813a996c608328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b32dc895188dfd76ee1cbc530eb07899b28f3aa9104f78febf1473598b50f8f2"
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
