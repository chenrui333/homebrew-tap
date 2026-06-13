class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "1ef135164e1bc9c04fa78f02a898ba0bec63e3fb3aa98f4e7a35dc98cc435b18"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a7fa96d514f17728f7e2a748fc05fdc13323b933c1bf04922ff6b741ce35bbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a7fa96d514f17728f7e2a748fc05fdc13323b933c1bf04922ff6b741ce35bbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a7fa96d514f17728f7e2a748fc05fdc13323b933c1bf04922ff6b741ce35bbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26ea244189bb2c5ca9646c33a4d970ff8f483bfb454cac1ba67959ea97add49d"
    sha256 cellar: :any,                 x86_64_linux:  "4fade6008663c10c6882999c034cc59894127b886858ef2a3934c6d7851a0ee9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    output = shell_output("#{bin}/lfk not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
