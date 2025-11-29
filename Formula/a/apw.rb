class Apw < Formula
  desc "CLI for Apple Passwords (also known as iCloud Keychain)"
  homepage "https://github.com/bendews/apw"
  url "https://github.com/bendews/apw/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "c0c3e00eb58ccd47fecf3f2fe0fd4bed9656887a3306fe9330234beb784868b9"
  license "GPL-3.0-only"
  head "https://github.com/bendews/apw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74d50662395e2b7885983e5f39b403aef5aa2b83fb8edc241275a778be59fd60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2851bed9684e44a3866e6667437c53aabfbf3e99969d10a3568e900fddc8bfe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1aa1914d33ea2733bce8789e469d1c9e10c1096f6c70c3b9e5f8f4bec966cc3b"
  end

  depends_on "deno" => :build
  depends_on :macos

  def install
    inreplace "src/const.ts", "1.0.1", version.to_s
    system "deno", "compile", "--allow-all", "--output", bin/"apw", "src/cli.ts"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apw --version")

    output = shell_output("#{bin}/apw pw list https://example.com 2>&1", 9)
    assert_match "Missing encryption key", output
  end
end
