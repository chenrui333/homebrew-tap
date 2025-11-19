class SpiffeHelper < Formula
  desc "Tool that can be used to retrieve and manage SVIDs on behalf of a workload"
  homepage "https://github.com/spiffe/spiffe-helper"
  url "https://github.com/spiffe/spiffe-helper/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "124b009c0dc737c5e5f7afd11eed4fe41b0ac9b98e98fc51cd1a49b38b3e6090"
  license "Apache-2.0"
  head "https://github.com/spiffe/spiffe-helper.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/spiffe/spiffe-helper/pkg/version.gittag=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/spiffe-helper"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spiffe-helper -version")

    output = shell_output("#{bin}/spiffe-helper 2>&1", 1)
    assert_match "helper.conf: no such file or directory", output
  end
end
