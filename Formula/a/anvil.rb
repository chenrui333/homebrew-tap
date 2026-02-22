class Anvil < Formula
  desc "CLI to streamline config management and tool installation"
  homepage "https://tryanvil.app"
  url "https://github.com/0xjuanma/anvil/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "bd8ce9c826f77ce28c793306576dd7961af68ad43bb605954c73082f4e6c2b2c"
  license "Apache-2.0"
  head "https://github.com/0xjuanma/anvil.git", branch: "master"

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
