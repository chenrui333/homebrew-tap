class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.34.tar.gz"
  sha256 "5505eb27e192cddb4811ad99f2866654cc0ad172f8853bb82214ce26f127c454"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c55f251b073410fd67940a74ec292852ef9c96cc851c1268949f4beadf7b303"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7df8d240f7f7fbed5cc125db846d14270f848846932a6034c8cdb64f82fe6639"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bfb1f8923007ba6a05ca090c640f017257c110a855ff278e441fc1ea0fe502b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ceeda11034d388776833ced54ad592bbaa5f2b51fb6bf6d4ad0a3ee14a8cfd5"
    sha256 cellar: :any,                 x86_64_linux:  "fa651f85c45a0b8b6f635216883312589c013b9595771fea548ed8621e408e08"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/RoninForge/budgetclaw/internal/version.version=#{version}
      -X github.com/RoninForge/budgetclaw/internal/version.commit=HEAD
      -X github.com/RoninForge/budgetclaw/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/budgetclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/budgetclaw version")
    assert_match "No activity tracked yet", shell_output("#{bin}/budgetclaw status")
  end
end
