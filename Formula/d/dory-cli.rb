class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.47.0.tgz"
  sha256 "bcd5d9c9dbeb7f762fab64edc4accaa695022fb7ef22b828bd7a493aff26bfd9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "690d00e81d57df0dce1fe2210960ddaa6136f375996b49a6f53589d7759e9e55"
    sha256 cellar: :any,                 arm64_sequoia: "992cf7154c90e25cb72f54d37c97900a1cf3f1b8004d93b12ed352d0e734ede6"
    sha256 cellar: :any,                 arm64_sonoma:  "992cf7154c90e25cb72f54d37c97900a1cf3f1b8004d93b12ed352d0e734ede6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e63129ae1fd55f041ca78a9ccb31a9c422c02cdd3e3c2f87b2717bfcfd6fba34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cf9364f34b86544f13b732a970808a002e59e8f9b8b54ea1ca75e64bda5ac6f"
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
