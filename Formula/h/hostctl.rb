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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a12fa09914274387cf504f8609c810019290a8109bc1849d2e3e9c745dc8956"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81a0d5821718a65966d6f87ac2c87886fa4ae71b7a22e8e79a1fdc06e4b00330"
    sha256 cellar: :any_skip_relocation, ventura:       "913802157946af5cc6669dfb836fddfe7266ea72fc12a918629db1dfda0572cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ca094692b76bdbb5dbd7dbe14fd97ff4cbfaafd9369232443581d31d6261157"
  end

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
