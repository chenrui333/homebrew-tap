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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bccaa631915e1fcfe34722002052465f19bd81479591333f926f7f2e4d406d1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0224d203b385351957c9b7bec4414351761d2b7c8a2f3dd9f3664139e08f5731"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ee6bce9b575a026302c2315ca972d1148533f0beb61809cd0aaee0888ffbb1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "636cff30e12cff6f3186af1930752446d59ed859078678e844282dbc3ae98629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a292a2b95f9ff97f715947a910aa739efd1bb7cd285b23c6a758c7ac7baeaa7"
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
