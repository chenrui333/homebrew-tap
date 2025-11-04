class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.23.0.tgz"
  sha256 "248fc98319550ca5f00cf2d107021ce4405a5ff9c23de6419ea8e3354ecb3a79"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "47668c5565a52c09a69dbfd2cd270d1649d5c78d219ef8110e4ced8e924c82aa"
    sha256                               arm64_sequoia: "25ffc0115d1da915177e1ade6978d163e0dfcc88e515e984953a49fab6d753cb"
    sha256                               arm64_sonoma:  "4436238537d2d659e2aefdd4007086035ca882969e55e0f55d3103d7a90094a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "147f4a86fa47d2138a65a787fc1d2681c4e54d06d5e92702da52920a2c5390a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efe3da2a9a9624a2c9386211a9b4d52fb5ade8dd46643dffc893e69fb69c3599"
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
