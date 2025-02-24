# framework: cobra
class Hostctl < Formula
  desc "Your dev tool to manage /etc/hosts like a pro"
  homepage "https://guumaster.github.io/hostctl/"
  url "https://github.com/guumaster/hostctl/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "c3df61772bb0f521def04e3fff2bda652725ee2dfb4c58e10456d84e94f67003"
  license "MIT"
  head "https://github.com/guumaster/hostctl.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/guumaster/hostctl/cmd/hostctl/actions.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/hostctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hostctl --version")
    assert_match "PROFILE", shell_output("#{bin}/hostctl list")
  end
end
