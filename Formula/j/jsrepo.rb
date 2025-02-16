class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.36.0.tgz"
  sha256 "780aae81814e5247809f5df7746450bfea7c8e45c6f12cabf3f54f70feff033a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59f129e54f53d509db7a6c1b0e7920eb9f580a85de41f425972364e4c89d89de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acc41d5070634a2a6ca97323898dfa9e5acd75cbae106ed7dc70540851440384"
    sha256 cellar: :any_skip_relocation, ventura:       "6e4b3be65793e9ee07c540565565bfb223037dd3b7bbe5656abe5021f0e88bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5f42e69a0c6a07a53f9465362b3a0d7fe9900ea293c66eba3d0842277c0508c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/jsrepo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end
