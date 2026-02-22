class Anvil < Formula
  desc "CLI to streamline config management and tool installation"
  homepage "https://tryanvil.app"
  url "https://github.com/0xjuanma/anvil/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "bd8ce9c826f77ce28c793306576dd7961af68ad43bb605954c73082f4e6c2b2c"
  license "Apache-2.0"
  head "https://github.com/0xjuanma/anvil.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "822173c395b58de82bb444a75b4f9f7ef8540c37c3b1422aab3cc5eca16be43a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "822173c395b58de82bb444a75b4f9f7ef8540c37c3b1422aab3cc5eca16be43a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "822173c395b58de82bb444a75b4f9f7ef8540c37c3b1422aab3cc5eca16be43a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "172956d32effb56e33cebd93734c11f06ef42fd4381706e09a63d1e7528d1326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dece0f35e045bc73329ededd090a95dff1428cf52c617ca56290f5348dd8f01"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/anvil --version")
    assert_match "Available Health Checks", shell_output("#{bin}/anvil doctor --list")
  end
end
