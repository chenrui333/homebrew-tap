class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "a59d7570083f0e88978fd37e202be72629cd6233bd2ad585d88a90030caa236c"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2802d2d78e7d7692ded696604d835c49b9bd7d6f351935f00b5047e958559870"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2802d2d78e7d7692ded696604d835c49b9bd7d6f351935f00b5047e958559870"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2802d2d78e7d7692ded696604d835c49b9bd7d6f351935f00b5047e958559870"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0e80dbc72b631c3137d16629cb9f42814d32b8891715d15cf83ffccf61ee802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1daf17f604e20b4fa91107dfa30c47c6cab12067deb036c09d0fd14f007b93fb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-doctor version")
    output = shell_output("#{bin}/aws-doctor --invalid-flag 2>&1", 1)
    assert_match "flag provided but not defined", output
  end
end
