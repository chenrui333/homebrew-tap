class Scrt < Formula
  desc "Secret manager for developers, sysadmins, and devops"
  homepage "https://scrt.run/"
  url "https://github.com/loderunner/scrt/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "72ac4c594e8c89b43d679118d571f2726a86628b324b33486fba4331b1dc39de"
  license "Apache-2.0"
  head "https://github.com/loderunner/scrt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04acae702dcda0d4ca814915c4da8d19028a34543380794eee98acb7f80a53bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04acae702dcda0d4ca814915c4da8d19028a34543380794eee98acb7f80a53bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aa0b0f047be76fceb5bd4fe8502e7a0f31c3a9b74d586efb95c6e79551e56b9"
    sha256 cellar: :any,                 x86_64_linux:  "b05fda0c3c738ec0284754a016515c1ed0e7c9981d8235171d96ed5e1a878346"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    # upstream bug report, https://github.com/loderunner/scrt/issues/1048
    # generate_completions_from_executable(bin/"scrt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrt --version")

    output = shell_output("#{bin}/scrt init --storage=local --password=p4ssw0rd --local-path=store.scrt")
    assert_match "store initialized", output
    assert_path_exists testpath/"store.scrt"
  end
end
