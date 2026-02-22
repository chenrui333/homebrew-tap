class Chiko < Formula
  desc "Beautiful gRPC TUI client for terminal-based API testing"
  homepage "https://github.com/felangga/chiko"
  url "https://github.com/felangga/chiko/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "b43b03caf132c0a4455176ee913829fae81fb55d4826848512b391944a36192a"
  license "MIT"
  head "https://github.com/felangga/chiko.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea2383370eefd2e562688d827ca902f463db2fcdd450541722e0b5cecd2f4c87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea2383370eefd2e562688d827ca902f463db2fcdd450541722e0b5cecd2f4c87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea2383370eefd2e562688d827ca902f463db2fcdd450541722e0b5cecd2f4c87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d43bc656d1799480eef4574ef1a1024f18a7ca09d8010ddd7b0f95ecbf02f553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2631235ade9dac17fae60884adc865ac2ae4fb6590c4ebbc91dec120ad4932d3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/chiko"
  end

  test do
    output = shell_output("#{bin}/chiko -insecure 2>&1", 1)
    assert_match "cannot use -plaintext and -insecure together", output
  end
end
