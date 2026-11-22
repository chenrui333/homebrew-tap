class ClogCli < Formula
  desc "Generate beautiful changelogs from your Git commit history"
  homepage "https://github.com/clog-tool/clog-cli"
  url "https://static.crates.io/crates/clog-cli/clog-cli-0.10.0.crate"
  sha256 "9508313c4df5a08a63a9bb8718c2d72125f9dec0cec350532d7b770083e70a71"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "51d2768b8840badf6044cd62fdec740a25153047e741ce29ded38f274ddbabd5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1404b8bb3c439615ab76b409d329a3591c03afcd55ec20bc6806b3f458a2fee4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb21c8216976e6303c6693ab5d6c277df4571ed710172d4cce8759a325a50ba1"
    sha256 cellar: :any,                 arm64_linux:   "ec042e8354faa82b45401dfecc7f311b3c5dcb2e22362d96b74036abec60f347"
    sha256 cellar: :any,                 x86_64_linux:  "5af48aa45ccd1aa4620318e1f916e1d6e3a81f19e63553f1cbfd11718d3e1df4"
  end

  depends_on "rust" => :build

  resource "clog" do
    url "https://static.crates.io/crates/clog/clog-0.11.0.crate"
    sha256 "a5c9eb664936079c4a138e5fdd19ebe8b284bbaf306dac76239c1a4220f0ebf7"

    # Fix the default Git grep expression for macOS's regex implementation.
    patch do
      url "https://github.com/clog-tool/clog-lib/commit/adf33667a024f6cf31eb18c104445342755ab56d.patch?full_index=1"
      sha256 "01c029d75a89ca82dd887fa9c61c0728576ce56c90b0b2c26bca73f16de55b8c"
      type :unofficial
      resolves "https://github.com/clog-tool/clog-lib/pull/29"
    end
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    resource("clog").stage buildpath/"clog"
    (buildpath/"Cargo.toml").open("a") do |f|
      f.puts "\n[patch.crates-io]\nclog = { path = \"clog\" }"
    end
    system "cargo", "update", "--offline", "--package", "clog"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clog --version")

    ENV["GIT_CONFIG_NOSYSTEM"] = "1"
    ENV["GIT_CONFIG_GLOBAL"] = File::NULL
    ENV["GIT_AUTHOR_DATE"] = ENV["GIT_COMMITTER_DATE"] = "2025-01-01T00:00:00Z"
    system "git", "init", "--quiet"
    system "git", "config", "user.name", "Homebrew Test"
    system "git", "config", "user.email", "test@brew.sh"
    system "git", "config", "commit.gpgsign", "false"

    system "git", "commit", "--quiet", "--allow-empty", "-m", "feat: previously released entry"
    system "git", "tag", "v0.1.0"
    system "git", "commit", "--quiet", "--allow-empty", "-m", "feat: add offline changelog fixtures"
    system "git", "commit", "--quiet", "--allow-empty", "-m", "fix: handle empty release notes"

    (testpath/".clog.toml").write <<~TOML
      [clog]
      [sections]
      Features = ["feat"]
      "Bug Fixes" = ["fix"]
    TOML
    system bin/"clog", "--from", "v0.1.0", "--outfile", "CHANGELOG.md"
    changelog = (testpath/"CHANGELOG.md").read
    assert_match "Features", changelog
    assert_match "add offline changelog fixtures", changelog
    assert_match "Bug Fixes", changelog
    assert_match "handle empty release notes", changelog
    refute_match "previously released entry", changelog
  end
end
