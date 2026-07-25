class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.87.1.tar.gz"
  sha256 "8ec193502c7cfbb2c95945316fa955259b25184569940c3d51edaba119af6df8"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5819f33612c92e6071c104645d42c87a6265c9a6a37a163106d46b69f35cc0b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fb519c9d45780caef595910678c512ccd056d106ad83268bed3a6594ac38847"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "842b5a7629995215c5de996fd4d88ce9d319efa2ff44d9ac5e3e71b09e3c448d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51f5e281434ebd5091fce5ee2efa9704afedd8ab18b6520857dc72cae2c0a492"
    sha256 cellar: :any,                 x86_64_linux:  "0cae23415e15c4622cee73512540e5e8e4d620aee9723e127992fa738e4ea1c4"
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
