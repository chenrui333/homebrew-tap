class Ax < Formula
  desc "Fetch, discover, and extract structured data from HTML and JSON"
  homepage "https://github.com/yusukebe/ax"
  url "https://github.com/yusukebe/ax/archive/refs/tags/v0.1.25.tar.gz"
  sha256 "b718e617348d232b7c72a40d55d7d54c1734fbaa392d09a92a35da240f4f5f6f"
  license "MIT"
  head "https://github.com/yusukebe/ax.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "771d04d1ee5777363473fbbba1b8950c3f275edb20e655c731b5d47f3b74ab5a"
  end

  depends_on "bun"

  deny_network_access!

  def fetch
    system formula_opt_bin("bun")/"bun", "install", "--frozen-lockfile", "--production", "--ignore-scripts"
  end

  def install
    libexec.install "src", "node_modules", "package.json"
    (bin/"ax").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("bun")}/bun" "#{libexec}/src/index.ts" "$@"
    SH
    chmod 0755, bin/"ax"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ax --version")
    (testpath/"page.html").write <<~HTML
      <html><body><article class="item"><h2 class="title">Homebrew</h2></article></body></html>
    HTML
    output = shell_output("#{bin}/ax page.html '.item' --row 'title=.title' --json")
    assert_equal [{ "title" => "Homebrew" }], JSON.parse(output)
    assert_equal "1", shell_output("#{bin}/ax page.html '.item' --count").strip
  end
end
