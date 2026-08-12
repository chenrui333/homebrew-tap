class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.97.0.tar.gz"
  sha256 "b098620146581c32bc591ff0c47dad377bcee7b792e29f736c9c87677904361f"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8fd657e80653687a2728859000ba91dcd310a257146dc4333979fc829ba5400"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c58480343dd444bfe59bac87ebeedea675b4f82be5bb1575fd062d6762814b29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34d8cd1b6ec2b3d2d0c95e0b69b6fe0c606f2d0814e68defa53cccc777031491"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a71fff7e8c7ed095a925028d0e484bead51214cbceda66eaea62067802b361bd"
    sha256 cellar: :any,                 x86_64_linux:  "2b791f29aea992ee15372ff7eab15f73f2691998b00659d9df795cf21496732f"
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
