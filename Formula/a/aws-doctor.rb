class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "a0c11ae71599b1ab89aa72045fa9cc10dcf70953c789ec11d383423843d3ecee"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6ac22d3ef17b328533354959631a7e490a5bd045ddce9e9ae29772270dc026e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6ac22d3ef17b328533354959631a7e490a5bd045ddce9e9ae29772270dc026e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6ac22d3ef17b328533354959631a7e490a5bd045ddce9e9ae29772270dc026e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee19c2455fe5017fcbc5d33b100554145a0ae7cd51240ecb135c47b60bf261b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eeb4ebdb3cec487daeb5a4df86a16759f2d349613b53a8d6c6e6f45a6abfbc4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-doctor version")
    output = shell_output("#{bin}/aws-doctor --invalid-flag 2>&1", 1)
    assert_match "unknown flag", output
  end
end
