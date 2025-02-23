class Yosay < Formula
  desc "Tell Yeoman what to say"
  homepage "https://github.com/yeoman/yosay"
  url "https://registry.npmjs.org/yosay/-/yosay-3.0.0.tgz"
  sha256 "5407cc98e1329d78f3e143ceeed6da82d8d75cf92a71700878ab40dbe711bb59"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbc05e2a410b01019dd390c58637486229587581474b05c97608bff4cb67008d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abd933f6d90b20087d50d0d47363792c5b47a62abad51dc66c614cdcf26b2119"
    sha256 cellar: :any_skip_relocation, ventura:       "ed3a28b6a26e97c14b0d5939029ecbcff10f7e17eecbcfd2f5d7014c19c9445d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e3f0161d8610c355b800e3e310a406a3ea49b9fd3061a5f93c6e8483611c4d0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/yosay"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yosay --version")
    assert_match "Hello, Homebrew!", shell_output("#{bin}/yosay 'Hello, Homebrew!'")
  end
end
