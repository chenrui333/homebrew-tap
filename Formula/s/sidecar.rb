class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "fd67b175a29bebd8da3f27c56ffbb174a02ed9df11ba4666f4070bcf9b5b609d"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8aae6985c7a4be6b42203715908a1414f60564a6764e8098bb15827e6a8cdf36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d926e45ec98723ed186a3275a6aecebdb7962e29d0c07abb7d93ab31643a524"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef4e1cb8601ada47c26be75ba2271b833058b3dd2a820ca65cae5d0582f87593"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ed911a6b74c7d569bd3ac9c8988ce3407b43e6b8d45090986907bafe523c4e8"
    sha256 cellar: :any,                 x86_64_linux:  "fa828c7869579c01a22d11739876256b08a5b03aaef88426dd0b7d2315fd5721"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"sidecar"), "./cmd/sidecar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sidecar --version")
    assert_match "Sidecar requires an interactive terminal",
                 shell_output("#{bin}/sidecar --project #{testpath} 2>&1", 1)
  end
end
