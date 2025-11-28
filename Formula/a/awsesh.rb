class Awsesh < Formula
  desc "TUI for AWS SSO session management"
  homepage "https://github.com/elva-labs/awsesh"
  url "https://github.com/elva-labs/awsesh/archive/refs/tags/v.0.1.11.tar.gz"
  sha256 "cad8808851902bde88c766b11178e93a444fa27ecebb4a6bf11f334b099ba90a"
  license "MIT"
  head "https://github.com/elva-labs/awsesh.git", branch: "main"

  depends_on "go" => :build

  def install
    # NOTE, the official binary should be sesh, but it would clash with https://github.com/joshmedeski/sesh
    # see discussions in https://github.com/elva-labs/awsesh/issues/34
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awsesh --version")
    assert_match "Error: Could not determine the last used SSO profile", shell_output("#{bin}/awsesh --browser")
  end
end
