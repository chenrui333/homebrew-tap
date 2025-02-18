# framework: cobra
class Cocainate < Formula
  desc "Cross-platform caffeinate alternative"
  homepage "https://github.com/AppleGamer22/cocainate"
  url "https://github.com/AppleGamer22/cocainate/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "c49a871e30647155f064704ae39084406d0506f52f8b1362b150e1bc239950e8"
  license "GPL-3.0-or-later"
  head "https://github.com/AppleGamer22/cocainate.git", branch: "master"

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
