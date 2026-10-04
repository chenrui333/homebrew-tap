class Lazytilt < Formula
  desc "Terminal interface for Tilt"
  homepage "https://github.com/tdi/lazytilt"
  url "https://github.com/tdi/lazytilt/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "7670e7436f241b2d8fbf9a3f7dd12bf21b04de8b995161a38ccb5dd3c590a889"
  license "MIT"
  head "https://github.com/tdi/lazytilt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c8577fe9b352a9c3e89399ad73e2f28ca829e87633febb135cbb50eadb4bbe9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c8577fe9b352a9c3e89399ad73e2f28ca829e87633febb135cbb50eadb4bbe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c8577fe9b352a9c3e89399ad73e2f28ca829e87633febb135cbb50eadb4bbe9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d896747caf69a232700a63c292b0b289c8de7c4d9542ae9bf93bbdc558e599c2"
    sha256 cellar: :any,                 x86_64_linux:  "e704c74000ffbd02da09424acd45584e92e1f964c839878fe0e66ad1bd15640a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazytilt --version")
    output = shell_output("#{bin}/lazytilt --invalid-option 2>&1", 2)
    assert_match "flag provided but not defined", output
  end
end
