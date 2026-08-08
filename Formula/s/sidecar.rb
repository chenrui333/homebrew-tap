class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.93.0.tar.gz"
  sha256 "f1cc3e4d702e595b094bd5e94695d1e5cf3382b3de860612ca4097ea07ce7eaa"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "180b08e9d58aa6d4768e591e67126bd1e4f2afd60f7f7d838a559dd9242c5e1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23e6c113d2be59fbfaeefbbb1f246c1d735a13484ef879d68aeb0538154ba3d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bccbf3cd38a27836073b5332b805ed167cf870e38a43599500b659bb60d9c7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78fb99a9117989e851135919d9122785c845a1389500bc3c46db06a441c616eb"
    sha256 cellar: :any,                 x86_64_linux:  "d0b69095d5bd8983362df03804f132a5df004ea9cc862c2348fdc7807e9b8207"
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
