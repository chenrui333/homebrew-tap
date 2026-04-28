class Datacmd < Formula
  desc "Auto-generative dashboards from different sources in your CMD"
  homepage "https://github.com/VincenzoManto/Datacmd"
  url "https://github.com/VincenzoManto/Datacmd/archive/refs/tags/v0.0.3.1.tar.gz"
  sha256 "15a1ffd74f667960b556f5b601991204b068217a71e2e350133dbb1c0f6a1f05"
  license "MIT"
  head "https://github.com/VincenzoManto/Datacmd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b11f2b9bce33dc893724d9dac77bdbe4092b74744c4046ae1d8a160cb17af7ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ec7edd654c2a5c362e0758dd0e304b48c7e508215861ccf2e15915352b1b807"
    sha256 cellar: :any_skip_relocation, ventura:       "dc23c8622ee3418daad721d2b42cebb9e522d3fce5963c29dd9326a9c9c0347a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb5c0b53d22f6b89f9339805834eab7e6fdc15589197441daee12bac83760ff8"
  end

  depends_on "go" => :build

  def install
    system "go", "mod", "tidy" # as it is missing `go.sum` file
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Error loading config or data", shell_output("#{bin}/datacmd -config does-not-exist.yml 2>&1", 1)
  end
end
