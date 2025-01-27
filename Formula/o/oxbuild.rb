class Oxbuild < Formula
  desc "Ultra fast and easy-to-use TypeScript/JavaScript compiler"
  homepage "https://github.com/DonIsaac/oxbuild"
  url "https://github.com/DonIsaac/oxbuild/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "834585e6e17339b96e22562db245d8a0852f468d0a6ddeaad1656f424b3800f8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "146e170393241ab037868bb984ef28368f3727aee1847a06af27e7c58e8025ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cf8266bf18e1c4b1c7616264a3e187509745e5aeffb08871b5a0fd10cf9b0a8"
    sha256 cellar: :any_skip_relocation, ventura:       "2dac585c749da1d02ce0b54903089f66ef132449b05b3e894406ab34f4043b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbad3be7020c091d992d6bcaa5230cdb9ccf1d91bd169cc10ec496ff290452f4"
  end

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
