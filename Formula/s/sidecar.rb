class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.78.0.tar.gz"
  sha256 "e3467039423f63accea8c711e8664d24ca58e8c116a3b760ee83eeb7200214cc"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ca3c7a732f6b206ea7037be115bae6b188a2b22d630cb69d35cbcec0fd661cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "697a94236bec8b8576b589b48d271a3cbe1012f345fa6e3672bfcb04c3b12b84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc2cd1bb3c78054bd08bddd73b783dac83a4ad0e23795bc98fd357dd1ae199ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c7cd1f278e321d5ca04bcb1f160189d5d4dfed18dd8842dabe042f1b985c485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b43bc34cd2349c05a35d84a0b2ae8daf3e3128e6043d1264859322b6f5fd19d"
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
