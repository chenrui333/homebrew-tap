class TttEditor < Formula
  desc "Terminal editor with LSP and Git integration"
  homepage "https://github.com/eugenioenko/ttt"
  url "https://github.com/eugenioenko/ttt/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "b01897fa241276c5dde42742899ae3dc806172eece0a41dea21b58f05eb78cac"
  license "MIT"
  head "https://github.com/eugenioenko/ttt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50d18c52717ec5f086b786bcfdec5ba5a6fb1b2a74110cc09296f6959efed93d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50d18c52717ec5f086b786bcfdec5ba5a6fb1b2a74110cc09296f6959efed93d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50d18c52717ec5f086b786bcfdec5ba5a6fb1b2a74110cc09296f6959efed93d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dd2f9c458b831065b5e4a3a4a6bf690c5f9257d34e349bf3ae0a7cdc236119e"
    sha256 cellar: :any,                 x86_64_linux:  "a3802ec386156e9df39d5372663a66f5374c91e264ae57c31709ec9fb70056a3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"ttt", ldflags: "-s -w -X main.version=#{version}"), "./cmd/ttt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttt --version")
    (testpath/"input.txt").write("homebrew\n")
    system bin/"ttt", testpath/"input.txt", "--exec",
           "wait-for homebrew; screenshot #{testpath}/screen.txt; quit"
    assert_match "homebrew", (testpath/"screen.txt").read
  end
end
