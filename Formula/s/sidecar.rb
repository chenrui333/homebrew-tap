class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.88.2.tar.gz"
  sha256 "1223b5deb5a0362d2fd5ecb5f5317c8fb3f7da10d69dcd8aa1e1336a200fedb2"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f872ec7482d7ce7289681c534e18429ff7c315b5971fbe86840ec9cc72b7a378"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b64d01c425358abcb24cdac9b2063490fdf7c681643f5fced7e95682c87a0ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48acdbb0cf206f8b05ec5246ad7c1230c4e1d7feb151d13a1baa50749d873644"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "379daac533305cebd3ebdd10fd1e2bc931e01480fb1ed11eb68860f126d9254a"
    sha256 cellar: :any,                 x86_64_linux:  "9317c100be25a70cca2cea7c269861b9f1033be323598967d01b5120651d79aa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"sidecar"), "./cmd/sidecar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sidecar --version")
    assert_match "sidecar requires an interactive terminal",
                 shell_output("#{bin}/sidecar --project #{testpath} 2>&1", 1)
  end
end
