class Apw < Formula
  desc "CLI for Apple Passwords (also known as iCloud Keychain)"
  homepage "https://github.com/bendews/apw"
  url "https://github.com/bendews/apw/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "f189a4e68a86f5ebbdfaf1b94533358f7452e5692057a348c27bf1decb7e3388"
  license "GPL-3.0-only"
  head "https://github.com/bendews/apw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "3e070e9f5ad7bf496f5fb80779a2f82dee38b61b4cac039d64afd168b9eafe2e"
  end

  depends_on "deno" => :build
  depends_on :macos

  def install
    system "deno", "compile", "--allow-all", "--output", bin/"apw", "src/cli.ts"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apw --version")

    output = shell_output("#{bin}/apw pw list https://example.com 2>&1", 9)
    assert_match "APW is not running or not authenticated", output
  end
end
