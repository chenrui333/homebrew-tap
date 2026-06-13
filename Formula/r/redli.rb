class Redli < Formula
  desc "Humane alternative to redis-cli with TLS support"
  homepage "https://github.com/IBM-Cloud/redli"
  url "https://github.com/IBM-Cloud/redli/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "a75de85b90466a088e39885b67c38cb3e7ceeee6f1ec82df3d1d88aee5a17a20"
  license "Apache-2.0"
  head "https://github.com/IBM-Cloud/redli.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/redli --version 2>&1")

    output = shell_output("#{bin}/redli --uri redis://localhost:1 2>&1", 1)
    assert_match(/connect|refused|dial/i, output)
  end
end
