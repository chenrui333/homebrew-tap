class Froggit < Formula
  desc "Modern, minimalist Git TUI"
  homepage "https://froggit-docs.vercel.app/"
  url "https://github.com/thewizardshell/froggit/archive/refs/tags/v1.2.0-beta.tar.gz"
  sha256 "9b3dc1b9669ae35b612abaa6d579b76b7ed78539a075efcdcc4de7e5e42dd113"
  license "MIT"
  head "https://github.com/thewizardshell/froggit.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Version:", shell_output("#{bin}/froggit -version")
    assert_match "Keyboard Shortcuts", shell_output("#{bin}/froggit -keys")
  end
end
