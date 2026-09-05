class Rdrview < Formula
  desc "Firefox Reader View as a command-line tool"
  homepage "https://github.com/eafer/rdrview"
  url "https://github.com/eafer/rdrview/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "e83266cb2e3b16a42f3433101d1f312350ce1442561eaded67efb51c2e8e8aab"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5e0bc150df30a2bbaaf06d3537741edf22e7a635eb93aa06d36596f2adf5263"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "706e2b1bc22bb54162a804bc1cd15aadcef103d955732c1c26bbe4de39d5719e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f2049f0dc1f470b9f809c090e301c954a31dc633d6030c74556cb5aeaca4091"
    sha256 cellar: :any,                 arm64_linux:   "d1c0f353c1c61e6267fbe974a2e604f651379c7f4b1ceb21540875677df453ba"
    sha256 cellar: :any,                 x86_64_linux:  "fe82f7f3d4318ef2b26951c4148540633ddb5b3766c6b8733d7bff63d1d5f90d"
  end

  depends_on "curl"
  depends_on "libxml2"

  on_linux do
    depends_on "libseccomp"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"source.html").write <<~HTML
      <!doctype html>
      <html>
        <head>
          <title>Homebrew Rdrview Test</title>
        </head>
        <body>
          <article>
            <h1>Reader View</h1>
            <p>Homebrew extracts this paragraph.</p>
          </article>
        </body>
      </html>
    HTML

    args = ["-H", "-u", "http://example.com"]
    args << "--disable-sandbox" if OS.mac?
    output = shell_output("#{bin}/rdrview #{args.join(" ")} < #{testpath}/source.html")
    assert_match "Homebrew extracts this paragraph.", output
    assert_match version.to_s, shell_output("#{bin}/rdrview --version")
  end
end
