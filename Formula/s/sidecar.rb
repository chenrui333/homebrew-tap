class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.90.0.tar.gz"
  sha256 "3e64a71b6ad972dcd2ab64b856eb623115e92a0aee1b59ed4e216c7f62040628"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5e35dd10bc5dc3889c006c90de3c212f5ca5a178ad7036b0b36be6de420b49f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba31e24214342a620f9339d1e3486e04fb4f6625a27eb62eb47d224af455c935"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42d306b0e3c34be18b2596eb0c58427d5e0514480cb96d32397b348cd631f106"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebf45682090c1530700ca702c3d24f07449630301cfcf89d04cb16088dcb2b0e"
    sha256 cellar: :any,                 x86_64_linux:  "51e52b9420d5bdcdb3fa63c2126184af779f0439b806126539a5c3d0bd1cc282"
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
