# framework: cobra
class Hostctl < Formula
  desc "Your dev tool to manage /etc/hosts like a pro"
  homepage "https://guumaster.github.io/hostctl/"
  url "https://github.com/guumaster/hostctl/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "c3df61772bb0f521def04e3fff2bda652725ee2dfb4c58e10456d84e94f67003"
  license "MIT"
  head "https://github.com/guumaster/hostctl.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00f6bad689ec110d62efe147d89ca8cac4a7f301e360947f88474f07ac1d0950"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00f6bad689ec110d62efe147d89ca8cac4a7f301e360947f88474f07ac1d0950"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1db6d3c5922db15dc08e22ab3cfdb4fa401e4f3e7b0f13317379b8574d2d6c95"
    sha256 cellar: :any,                 x86_64_linux:  "0ffd8b69b63da5ef8fac184276a75c53c460eb94494814fadfd24b7cf8773f70"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/guumaster/hostctl/cmd/hostctl/actions.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/hostctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hostctl --version")
    assert_match "PROFILE", shell_output("#{bin}/hostctl list")
  end
end
