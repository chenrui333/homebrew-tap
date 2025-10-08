class Datacmd < Formula
  desc "Auto-generative dashboards from different sources in your CMD"
  homepage "https://github.com/VincenzoManto/Datacmd"
  url "https://github.com/VincenzoManto/Datacmd/archive/refs/tags/v0.0.3.1.tar.gz"
  sha256 "15a1ffd74f667960b556f5b601991204b068217a71e2e350133dbb1c0f6a1f05"
  license "MIT"
  revision 1
  head "https://github.com/VincenzoManto/Datacmd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f1f08c3c942e167642efd382542487fb8671d37ec40cde54dc0242cd1d70da6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1978aa5c6acff5167527f5c148c39f0ef14cac5d80730b36612daa575f706e0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88cea9dd3e34045563194ebbb4deffee40f185f45ef04aad2e267e1afa16d7bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "915b7c142f21782fed51f16d7402665fa21f9457f422cd8bd5837d3e6428dc72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aad098cdecdec9a87974a3419999d0286cbf685f75cd0e1c53d28b7e020eda58"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    system "go", "mod", "tidy" # as it is missing `go.sum` file
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Error loading config or data", shell_output("#{bin}/datacmd -config does-not-exist.yml 2>&1", 1)
  end
end
