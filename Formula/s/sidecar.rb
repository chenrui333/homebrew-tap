class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.96.0.tar.gz"
  sha256 "9361c3a96ead9cd8da3bb05bf38f96bc83f2151fec0be48d85341c2343eb0f81"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea3e682eccf2979d2e726c4e5096e781c6d801374eedd92c587e6b0cc4c2ce29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffdce1597b8db73a27d2e7c30dc57c0e3d7eca0f2722016e5001885f5d87c4cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be79339ea19408d3b2043155a791641f52e34b7eac811ab2710cd07d55b2fb5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d1eacfb359d806a9bee3e84b9e995c3e1e1508ce07cd0108ebbdada289933b9"
    sha256 cellar: :any,                 x86_64_linux:  "2368f8c84e49847b87c88632aaf59009bd095580d4b247c2bfb839f24f7770fe"
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
