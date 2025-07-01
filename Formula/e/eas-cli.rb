class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.13.3.tgz"
  sha256 "d9ad3ead75ac9c2b7be85c2f87b567f11558895ad8d3f53b8770437336125a3a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92a06907041536669cb0d18999844800ce04106f5e6a045236f3343165a6afca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72bef5c244618a19396ff7a9882fa5842eb25abebf4bf54a5082048ac07e44cb"
    sha256 cellar: :any_skip_relocation, ventura:       "de83550a9e3c1bb4ed600016ce5d0ccb18cf703bd142d1db5b0d56f035a6c703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b3f36c753bc984b01bfe00d31fcb1ed550bcfdde51d1917afcbac87657301fb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")

    assert_match "Not logged in", shell_output("#{bin}/eas whoami 2>&1", 1)
    output = shell_output("#{bin}/eas config 2>&1", 1)
    assert_match "Run this command inside a project directory", output
  end
end
