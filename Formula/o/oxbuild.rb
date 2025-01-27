class Oxbuild < Formula
  desc "Ultra fast and easy-to-use TypeScript/JavaScript compiler"
  homepage "https://github.com/DonIsaac/oxbuild"
  url "https://github.com/DonIsaac/oxbuild/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "834585e6e17339b96e22562db245d8a0852f468d0a6ddeaad1656f424b3800f8"
  license "MIT"

  depends_on "rust" => :build
  depends_on "node" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxbuild --version")

    (testpath/"src/test.ts").write <<~TYPESCRIPT
      export function greet(name: string): string {
        return `Hello, ${name}!`;
      }
      console.log(greet("Homebrew"));
    TYPESCRIPT

    system bin/"oxbuild"
    output = shell_output("node #{testpath}/dist/test.js")
    assert_match "Hello, Homebrew", output
  end
end
