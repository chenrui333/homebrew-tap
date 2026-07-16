class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.29.2.tar.gz"
  sha256 "61a934df8a87bba112828545fef2f4d3ee1b40edfc7c0f72b8b6c6c2bdb6d8bf"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b7c3186f9cbd03bac1c70825c60848101cd03ef252ee8d2d5cfcb60d2819b2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d28ead4acc3c7d80153264e66a39892bfc32dc0219aedf75d7fe5aa746e2040"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42305bdedef9b13e2635b94a45d60d504a26b8aa8c5cd0b0c53512fda6c7e2df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51ac0d10eba020ec65cb9d9f61ad8107c5c8dd0438319797edf7ae0113e4ffb9"
    sha256 cellar: :any,                 x86_64_linux:  "652bf2661fc81fbf937d0ef7fec234bf0d99d3000a93c600f8c6e43735287381"
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
