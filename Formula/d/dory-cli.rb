class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.30.0.tgz"
  sha256 "13c8642f61633852a138950c5a13d9988656375c4483d5b96e174e20f1f6a08d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "615f5c4d4996fb0efff81aa84c8fea42805eb61405c0e4b969d39fd5b89a48fb"
    sha256                               arm64_sequoia: "3e85bcd4ba0288b3f2944d6abbbd11a1111ef938015636cd0361e7adb6aced89"
    sha256                               arm64_sonoma:  "020e352a7ca7b27cf45e7984648cc03858e518b59d41046fd36f9b5e4fadbd42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a901c21539049d28be4dc67d60a72da12e22b7dba9880051dbbd4c22b07df928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c55eb73fe7225114865ee63971e60831d833b7e5c9b0f520a28ab102d51129a7"
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
