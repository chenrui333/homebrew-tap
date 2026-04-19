class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "828dbf04cbef099ecc263578ece7294747b37df5a34a12326b36c13a70a2bad5"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17eb1c3591b405c50aa85389d0a55886ead6c5b275bac8b2cc3a5fa5f88fa699"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17eb1c3591b405c50aa85389d0a55886ead6c5b275bac8b2cc3a5fa5f88fa699"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17eb1c3591b405c50aa85389d0a55886ead6c5b275bac8b2cc3a5fa5f88fa699"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "953ec60919ed67000653d56de20d6de3ecbd46b756e48c2960827ead82ada60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2472677978185ae1691f633943f89f895a63850aa35efa49c79763fc52d75565"
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
