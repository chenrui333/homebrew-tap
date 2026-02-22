class Parm < Formula
  desc "Cross-platform package manager for GitHub Releases"
  homepage "https://github.com/alxrw/parm"
  url "https://github.com/alxrw/parm/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "04c782bd4d12410314720bc40fa91410447d1176270c2eed425cc677d138facd"
  license "GPL-3.0-only"
  head "https://github.com/alxrw/parm.git", branch: "master"

  depends_on "go" => :build

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
