class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "acb177529b7b64afbfe7177f5be0d51c91373e9f4133d08923f8f5517dc42b63"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fbbb27084e889ea3b11ef66fbb735153dc7785bd7f3c3a054ed99398baedc72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fbbb27084e889ea3b11ef66fbb735153dc7785bd7f3c3a054ed99398baedc72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fbbb27084e889ea3b11ef66fbb735153dc7785bd7f3c3a054ed99398baedc72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56a2ef15048f5dc43a77e2fec12e61e154c9ce1e4abd5a45350f5e4f8a1a08e2"
    sha256 cellar: :any,                 x86_64_linux:  "1713c3f853fdb84d02cc07e66cc1e69bfd638a790e7f1de043d845ac913acc27"
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
