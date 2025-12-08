class Froggit < Formula
  desc "Modern, minimalist Git TUI"
  homepage "https://froggit-docs.vercel.app/"
  url "https://github.com/thewizardshell/froggit/archive/refs/tags/v0.5.0-beta.tar.gz"
  sha256 "ba3b2f046929e9cca45e06d65cbcbdf1c16cd15ba835f44c0b0b74c2580a6067"
  license "MIT"
  head "https://github.com/thewizardshell/froggit.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/froggit -version")
    assert_match "Keyboard Shortcuts", shell_output("#{bin}/froggit -keys")
  end
end
