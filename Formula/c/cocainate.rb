# framework: cobra
class Cocainate < Formula
  desc "Cross-platform caffeinate alternative"
  homepage "https://github.com/AppleGamer22/cocainate"
  url "https://github.com/AppleGamer22/cocainate/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "c49a871e30647155f064704ae39084406d0506f52f8b1362b150e1bc239950e8"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/AppleGamer22/cocainate.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1680c934a297eb482d3a9518a587a44ab2fd11b49ef1bf0b1246e10d8408d316"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "140eca5b92915250988b9002a3023f38b93f67f2d974117ea0cc11f952f1d50b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "761c072af5c6aa75bfdf7052894b23b0d0a3fa32d95c19d7e57aa1be9b86b776"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a81050c4544b8477149cbc85bdfbb2595a4a97037ad3244c68d4bc73754e2e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98e40e0bac7c6baa2a13f3667b7c26ca1e32682454790b88e60e6186e129c87b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/AppleGamer22/cocainate/commands.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cocainate", "completion")
    (man1/"cocainate.1").write Utils.safe_popen_read(bin/"cocainate", "manual")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cocainate --version")

    # Fails in Linux CI with
    # `The name org.freedesktop.ScreenSaver was not provided by any .service files`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"cocainate", "--duration", "1s"
  end
end
