class Rdrview < Formula
  desc "Firefox Reader View as a command-line tool"
  homepage "https://github.com/eafer/rdrview"
  url "https://github.com/eafer/rdrview/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "e83266cb2e3b16a42f3433101d1f312350ce1442561eaded67efb51c2e8e8aab"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f2402bb442b97c0d4f95f7a42871f30e3b5fd95f2145bff6fceb9909b09138b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1537e35fd05e090172104afa8fccece612dec75f4fe9582fce9ce60a75bfbdd5"
    sha256 cellar: :any,                 arm64_linux:   "f832103e5c70d24d85b3cbd64067e3504bea71ff49b32a0e415afb4db56b52b0"
    sha256 cellar: :any,                 x86_64_linux:  "2f03891baf51329ea94736e5ffbee97a45bd1c2ace2393c3b3c472b93295ba92"
  end

  depends_on "curl"
  depends_on "libxml2"

  on_linux do
    depends_on "libseccomp"
  end

  deny_network_access!

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
