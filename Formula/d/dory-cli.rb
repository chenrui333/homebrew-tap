class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.36.0.tgz"
  sha256 "6b5fbc7ec0a7466b5977058743d2da93806e3d34b3e9a11436d4f3b9f28465bb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "3786c3a605228a18d23b95348d8d60f334734016c93ab22aa3013defa327d513"
    sha256                               arm64_sequoia: "87316821e49d4bcd17ddeafc55e6977008f23124b69664cc72949db90b7abb7a"
    sha256                               arm64_sonoma:  "01b0eeb628dd75947fe9038d781783746f6f1b5a5086b5f3edd4e0fde0a602f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cca92d241f5dde3177cf14f84c614449fcee275d15734a79b6c58d9f1425029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82afce9ea2436aa08dbc1870bceca654497be625a05de52262096d4e5cd53f32"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    if OS.linux?
      (libexec/"lib/node_modules/@clidey/dory/node_modules")
        .glob("sass-embedded-linux-musl-*")
        .each(&:rmtree)
    end
  end

  test do
    output = shell_output("#{bin}/dory build 2>&1", 1)
    assert_match "Dory is ready to build your docs", output
  end
end
