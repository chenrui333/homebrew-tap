class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.31.1.tar.gz"
  sha256 "7749c031ff6fc6068a5ba70620c66999d7816601123b5002552767b3e26e633c"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ae755623d4edbe365702bb56d4b910a49be1c0bcc66f30780099a1478bea144"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "372187efd4e6c5102ec2ba364bf7bc96d983d8202f767a55cc12873322a9a929"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7fa770425951b1c8d3da693aca25ff831e1b55c8df4bc1248e80a2f93ae32c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "978fd315d8ec34b3bcf18de8220562684cedae14c59be3b95c1df2328b61b8bc"
    sha256 cellar: :any,                 x86_64_linux:  "0604d769f805a683a43f2f8a872e0a115b3af93705f331d79fa3ecaf3c2ae90c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnspec/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cnspec version")

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
