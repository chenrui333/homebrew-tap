class Gittop < Formula
  desc "Beautiful terminal UI for visualizing Git repository statistics"
  homepage "https://github.com/hjr265/gittop"
  url "https://github.com/hjr265/gittop/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "3201fbdcbcc7599e8b74bc4d81ace139cefa30c83130e75e20a3016a17fc312b"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6138bc85407e5b02bc9555bd051ac9d4f500c06b7bd8c3ba2cb17ef7bd87c00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6138bc85407e5b02bc9555bd051ac9d4f500c06b7bd8c3ba2cb17ef7bd87c00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e378a0bc63a7860a36148b61ab12bb8824e74577a9680b01049123d3592c999"
    sha256 cellar: :any,                 x86_64_linux:  "cd3b1f70dc381e99268e965ce685f32568140b0ab52aeb710ce354ccf104da9a"
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
