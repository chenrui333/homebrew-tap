class Rdsview < Formula
  desc "Firefox Reader View as a command-line tool"
  homepage "https://github.com/eafer/rdrview"
  url "https://github.com/eafer/rdrview/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "e83266cb2e3b16a42f3433101d1f312350ce1442561eaded67efb51c2e8e8aab"
  license "Apache-2.0"

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
