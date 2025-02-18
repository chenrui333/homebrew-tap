# framework: cobra
class Cocainate < Formula
  desc "Cross-platform caffeinate alternative"
  homepage "https://github.com/AppleGamer22/cocainate"
  url "https://github.com/AppleGamer22/cocainate/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "c49a871e30647155f064704ae39084406d0506f52f8b1362b150e1bc239950e8"
  license "GPL-3.0-or-later"
  head "https://github.com/AppleGamer22/cocainate.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91c81a350c430224019d60681b169ef98fbe8401ecfca9e7562be77e6e2580f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d484ca4d926579b48281c4a6674237d77c95a08fb7037b4c5d5bb84479cbc027"
    sha256 cellar: :any_skip_relocation, ventura:       "dfa23a0c3c4fb8c1cd19ea33ac52b1a8da7845edc0df2b07d104032482030650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3827812184a94d8c4c2c26476d2a8c2e4b1d660e99629b3870102252d42baab"
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
