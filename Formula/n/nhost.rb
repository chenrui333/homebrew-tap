class Nhost < Formula
  desc "Developing locally with the Nhost CLI"
  homepage "https://docs.nhost.io/development/cli/overview"
  url "https://github.com/nhost/cli/archive/refs/tags/v1.29.9-jovermier.tar.gz"
  version "1.29.9-jovermier"
  sha256 "c95df107ce96962294d737d45960b514a3c4fcacf5cf82ff94aab413456daed7"
  license "MIT"
  head "https://github.com/nhost/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ad5ba09f8c95ca79621528907a1481444bfac6aef432ea0c3dadb8485005cb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd3b7790a8a78bb37b3e7f8068b1da2fd6a2a833cf8c272f12500960b494fd11"
    sha256 cellar: :any_skip_relocation, ventura:       "45e8cf6156c84a278cb5fca73f92e55b4bdb0ee1778d92513de986da74e96279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fba651b0bab56ff3a3e6354cf52ee39129fa7d06590c932dee0620790b4aed6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nhost --version")

    system bin/"nhost", "init"
    assert_path_exists testpath/"nhost/config.yaml"
    assert_match "[global]", (testpath/"nhost/nhost.toml").read
  end
end
