class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.34.1.tgz"
  sha256 "d65039c418ff70e9ac02f001f90b6e1df844dfc1a92af649f2fe8a7f1c94bd7e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "617f24a0edafad2af0842ae75e6cce8203e3c266f3f6198e36409b18087075bf"
    sha256                               arm64_sequoia: "8741c9dd1d4a286ebcb5ac7b9a5c6a56583b5a9ca5acbfe99dfcc4d199109074"
    sha256                               arm64_sonoma:  "dbcadaf8aba8317d9b5a37a2f24886fd7e98ec4c33d53cd3f6ca3c2685427eff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30bcff121c4e1854e09c11e97d938c41da96bde0a8754fa83c7623dd4ab7f0b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcf4a1f6322984fe9639e5fa8f4c7bbbac5ecafddcdf76d5cd9585ea035512c8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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
