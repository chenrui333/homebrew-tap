class Parm < Formula
  desc "Cross-platform package manager for GitHub Releases"
  homepage "https://github.com/alxrw/parm"
  url "https://github.com/alxrw/parm/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "04c782bd4d12410314720bc40fa91410447d1176270c2eed425cc677d138facd"
  license "GPL-3.0-only"
  head "https://github.com/alxrw/parm.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ac8cd5a01ccc60bc4076d22301f4b10d861d5a841de5c9d0e3ef9800332575a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f4f4fec21efa50a519b1075144f50a8a7853cf8cc4ef1795242ebf4288ba1fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a763de50fe9d048a2a52dddc66f69df5bb81a269f9563773262908dddefea4d7"
    sha256 cellar: :any,                 x86_64_linux:  "ff2c9ca60f5745bd512720b8159247ebbd82ff09516e486ad66c436d26f5c968"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X parm/parmver.StringVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath

    assert_match version.to_s, shell_output("#{bin}/parm --version")
    assert_match "Total: 0 packages installed.", shell_output("#{bin}/parm list")
  end
end
