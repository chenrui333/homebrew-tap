class Ctxmv < Formula
  desc "Migrate conversation sessions between AI coding agents"
  homepage "https://github.com/Ryu0118/ctxmv"
  url "https://github.com/Ryu0118/ctxmv/archive/refs/tags/0.5.0.tar.gz"
  sha256 "77254a014bb9dd14a79122f7a05cee3880f53b99f5bb912f4c5b1170e79405df"
  license "MIT"
  head "https://github.com/Ryu0118/ctxmv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2c7b0f8fac67a7748449eb1d8391294bbd0741934e50c2d37cc0824d06cf8bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd72023f8bf153c2859c0618a7484873da2f45c7502dc206baef5b51e2b1beab"
    sha256 cellar: :any_skip_relocation, sequoia:       "caf5dff13120acc5edb707bc5d6a8a3f59a0bae284316de185c2a5a1d2552400"
  end

  depends_on xcode: ["16.0", :build]
  depends_on :macos
  depends_on macos: :sequoia

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/ctxmv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctxmv --version")
    output = shell_output("#{bin}/ctxmv list --source codex --project #{testpath} --limit 1")
    assert_match "No sessions found.", output
  end
end
