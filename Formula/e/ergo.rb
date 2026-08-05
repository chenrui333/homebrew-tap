class Ergo < Formula
  desc "Modern IRC server (daemon/ircd) written in Go"
  homepage "https://github.com/ergochat/ergo"
  url "https://github.com/ergochat/ergo/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "7b1f6fac874a75c766ccd41d068f4408ac09aa30e594233afe87e7793d93c587"
  license "MIT"
  head "https://github.com/ergochat/ergo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa2d00b7bafdd35a08a03dc790c68c4642a8149c9580b95850f891d7c38d4366"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa2d00b7bafdd35a08a03dc790c68c4642a8149c9580b95850f891d7c38d4366"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa2d00b7bafdd35a08a03dc790c68c4642a8149c9580b95850f891d7c38d4366"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4fcca9b1de5a57286dc6edfbeeeccdf34e4b15a88587cad538b7291bd17a502"
    sha256 cellar: :any,                 x86_64_linux:  "121ef001f8c326a02c2571a9e87c698617377036a9a43528581ec07c83b33f41"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ergo --version")

    output = shell_output("#{bin}/ergo defaultconfig")
    assert_match "# This is the default config file for Ergo", output
  end
end
