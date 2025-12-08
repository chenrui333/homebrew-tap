class SuperstarryeyesBit < Formula
  desc "CLI/TUI logo designer with ANSI fonts, gradients, shadows, and exports"
  homepage "https://github.com/superstarryeyes/bit"
  url "https://github.com/superstarryeyes/bit/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "b58bf458db0d8f2f5ee48628bcc9b7aaacccda0ab7d4216c5e404aa0e83e02f2"
  license "MIT"
  head "https://github.com/superstarryeyes/bit.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37cf914cce28902ed07550376d8d0ec6a7b4131e0f427f046614df6761a4c27a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37cf914cce28902ed07550376d8d0ec6a7b4131e0f427f046614df6761a4c27a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37cf914cce28902ed07550376d8d0ec6a7b4131e0f427f046614df6761a4c27a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0abaaa04fff3736926dd9c0d2262df7ae3f2630511e17eb5f1cc4113357495a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cca77cb12a423857ab48b86ad48a337218cf5afe287d671b6917cd7da3fd7c0a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"bit"), "./cmd/bit"
  end

  test do
    assert_match "Available fonts", shell_output("#{bin}/bit -list")
  end
end
