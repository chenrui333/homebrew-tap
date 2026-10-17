class Gittop < Formula
  desc "Beautiful terminal UI for visualizing Git repository statistics"
  homepage "https://github.com/hjr265/gittop"
  url "https://github.com/hjr265/gittop/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "f6d0a81e8582453b44bb8dc7dcbf7dce51c9889e5382b61fb4597910ee388fc3"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83cbdb7cfa5cfdb5b3f9c9b1f0b36e91965bacd0c5df0b481d14bf930eb4af3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83cbdb7cfa5cfdb5b3f9c9b1f0b36e91965bacd0c5df0b481d14bf930eb4af3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0f60aa8cd315d0b1472ea472d081ccf62b021f87f2863bba0732f7b176bd598"
    sha256 cellar: :any,                 x86_64_linux:  "037118bfe273a31ea3759a78a53e1861bcc067b7b726b6f5d74814dde359a57f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "Homebrew"
    system "git", "config", "user.email", "brew@example.com"
    (testpath/"README.md").write("hello from Homebrew\n")
    system "git", "add", "README.md"
    system "git", "commit", "-m", "init"

    command = if OS.mac?
      "printf 'q' | script -q /dev/null #{bin/"gittop"} #{testpath}"
    else
      "printf 'q' | script -qefc '#{bin/"gittop"} #{testpath}' /dev/null"
    end

    output = shell_output("#{command} 2>&1")
    assert_match "q", output
  end
end
